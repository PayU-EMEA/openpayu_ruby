module OpenPayU
  module Documents
    class Request < Document
      attr_accessor :header, :data

      def initialize(data)
        @data = data
        set_headers
      end

      def set_headers
        @header = {
          'OpenPayu-Signature' => generate_signature_structure(@data, OpenPayU::Configuration.algorithm, OpenPayU::Configuration.merchant_pos_id, OpenPayU::Configuration.signature_key)
        }
      end

    end
  end
end