module OpenPayU
  module Documents
    class Response < Document
      attr_accessor :parsed_data, :response, :request, :message_name, :body

      def initialize(data, message_name)
        @response = data[:response]
        @request = data[:request]
        @message_name = message_name
        @body =  @response.body.is_a?(StringIO) ? @response.body.string : @response.body
        parse_data if verify_response
      end

      def method_missing(method_name)
        @parsed_data[method_name.to_s]
      end

      def parse_data
        if OpenPayU::Configuration.data_format == "xml"
          @parsed_data = Hash.from_xml(@body)
        else
          @parsed_data = JSON.parse(@body)
        end
        if @parsed_data["OpenPayU"] && @parsed_data["OpenPayU"][@message_name]
          @parsed_data = underscore_keys @parsed_data["OpenPayU"][@message_name]
        elsif @parsed_data["OpenPayU"]
          @parsed_data = underscore_keys @parsed_data["OpenPayU"]
        end
        @parsed_data
      end

      def order_status
        if @message_name == "OrderRetrieveResponse"
          @parsed_data["orders"]["order"]["status"]
        else
          @parsed_data["order"] ? @parsed_data["order"]["status"] : ""
        end
      end

      %w(NEW PENDING CANCELLED REJECTED COMPLETED WAITING_FOR_CONFIRMATION).each do |method|
        define_method((method.downcase + "?").to_sym) { order_status == method}
      end

    end
  end
end
