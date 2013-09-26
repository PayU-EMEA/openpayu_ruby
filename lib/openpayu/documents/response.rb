module OpenPayU
  module Documents
    class Response < Document
      attr_accessor :parsed_data, :response, :request, :message_name

      def initialize(data, message_name)
        @response = data[:response]
        @request = data[:request]
        @message_name = message_name
        parse_data if verify_response
      end

      def method_missing(method_name)
        @parsed_data[method_name.to_s]
      end

      def parse_data
        if OpenPayU::Configuration.data_format == "xml"
          @parsed_data = Hash.from_xml(@response.body)
        else
          @parsed_data = JSON.parse(@response.body)
        end
        if @parsed_data["OpenPayU"] && @parsed_data["OpenPayU"][@message_name]
          @parsed_data = underscore_keys @parsed_data["OpenPayU"][@message_name]
        elsif @parsed_data["OpenPayU"]
          @parsed_data = underscore_keys @parsed_data["OpenPayU"]
        end
        @parsed_data
      end

      def order_status
        @parsed_data["orders"]["order"]["status"]
      end

      %w(NEW PENDING CANCELLED REJECTED COMPLETED WAITING_FOR_CONFIRMATION).each do |method|
        define_method((method.downcase + "?").to_sym) { order_status == method}
      end

    end
  end
end
