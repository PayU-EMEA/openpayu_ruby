# -*- encoding : utf-8 -*-
module OpenPayU
  module Documents
    class Response < Document
      attr_accessor :parsed_data, :response, :request, :body

      def initialize(data)
        @response = data[:response]
        @request = data[:request]
        @body = @response.body.is_a?(StringIO) ? @response.body.string :
          @response.body
        parse_data if verify_response
      end

      def method_missing(method_name)
        @parsed_data[method_name.to_s]
      end

      def parse_data
        @parsed_data = underscore_keys JSON.parse(@body)
      end

      def status
        @parsed_data['status']
      end

       def order_status
        @parsed_data['orders']['orders'][1]['status']
      end

      Models::Order::STATUSES.each do |method|
        define_method((method.downcase + '?').to_sym) { order_status == method }
      end

    end
  end
end
