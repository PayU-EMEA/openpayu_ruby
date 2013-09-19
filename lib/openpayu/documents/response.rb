require "active_support/core-ext/hash"

module OpenPayU
  module Documents
    class Response < Document

      def initialize(data)
        if OpenPayU::Configuration.data_format == "xml"
          data = Hash.from_xml(data)
        else
          data = JSON.parse(data)
        end
        if data["OpenPayU"] && verify_response(data)
          verify_response(data)
        end

      end


       def verify_response(response, message_name)

       end
    


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