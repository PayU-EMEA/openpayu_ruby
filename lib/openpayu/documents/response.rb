require "active_support/core_ext/hash"

module OpenPayU
  module Documents
    class Response < Document
      attr_accessor :parsed_data

      def initialize(data, headers = [])
        if data
          if OpenPayU::Configuration.data_format == "xml"
            @parsed_data = Hash.from_xml(data)
          else
            @parsed_data = JSON.parse(data)
          end

          # incoming_signature = get_signature(headers);
          if @parsed_data["OpenPayU"] && true #verify_response(data, parsed_data, "message_name?")

          end
        else
          #empty data!
        end
        @headers = headers
      end

      def method_missing(method_name)
        @parsed_data[method_name]
      end


      def verify_response(response, parsed_data, message_name)
        if verify_signature(response, get_signature)
        end
    #     if ($httpStatus == 200 || $httpStatus == 201 || $httpStatus == 422 || $httpStatus == 302)
    #         return $result;
      end


  def verify_signature(message, algorithm, signature, signature_key)
    generate_signature(message, algorithm, signature_key) == signature
  end


        # $incomingSignature = self::getSignature(self::$headers);

        # if(!empty($incomingSignature))
        # {
        #     $sign = OpenPayU_Util::parseSignature($incomingSignature);

        #     if(false === OpenPayU_Util::verifySignature($response, $sign->signature, OpenPayU_Configuration::getSignatureKey(), $sign->algorithm))
        #         throw new OpenPayU_Exception_Authorization('Invalid signature - ' . $sign->signature);
        # }

        def get_signature

        end
    # public static function getSignature($headers)
    # {
    #     foreach($headers as $name => $value)
    #     {
    #         if(preg_match('/X-OpenPayU-Signature/i', $name))
    #             return $value;
    #     }
    # }

    #     } elseif (isset($message['OpenPayU'])) {
    #         $status = isset($message['OpenPayU']['Status']) ? $message['OpenPayU']['Status'] : null;
    #         $data['Status'] = $status;
    #         unset($message['OpenPayU']['Status']);
    #     }

    #     $result = self::build($data);

    #     if ($httpStatus == 200 || $httpStatus == 201 || $httpStatus == 422 || $httpStatus == 302)
    #         return $result;
    #     else {
    #         OpenPayU_Http::throwHttpStatusException($httpStatus, $result);
    #     }

    #     return null;
    # }

  end
end
end