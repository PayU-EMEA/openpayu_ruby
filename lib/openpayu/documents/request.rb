module OpenPayU
  module Documents
    class Request < Document

      def initialize(data)
        if OpenPayU::Configuration.data_format.downcase == "xml"
          data = order.to_xml
        else 
          data = order.to_json
        end
        data
        generate_signature(data, OpenPayU::Configuration.algorithm, OpenPayU::Configuration.signature_key)

      end

    end
  end
end