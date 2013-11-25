# -*- encoding : utf-8 -*-
module OpenPayU
  module Documents
    class Request < Document
      attr_accessor :headers, :body

      def initialize(data)
        @body = data
        set_headers
      end

      def set_headers
        @headers = {
          'OpenPayu-Signature' => generate_signature_structure(
              @body,
              OpenPayU::Configuration.algorithm,
              OpenPayU::Configuration.merchant_pos_id,
              OpenPayU::Configuration.signature_key
            ),
          'openpayu-signature' => generate_signature_structure(
              @body,
              OpenPayU::Configuration.algorithm,
              OpenPayU::Configuration.merchant_pos_id,
              OpenPayU::Configuration.signature_key
            )
        }
      end

      def [](header_name)
        @headers[header_name]
      end
    end
  end
end
