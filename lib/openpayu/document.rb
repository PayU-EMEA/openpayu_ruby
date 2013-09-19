require "digest"
module OpenPayU

  class Document


    def generate_signature_structure(data, algorithm, merchant_pos_id = "", signature_key = "")
      raise WrongConfigurationError, "Merchant Signature Key (signature_key) should not be null or empty." if signature_key.empty?
      raise WrongConfigurationError, "Merchant Pos Id (merchant_pos_id) should not be null or empty." if signature_key.empty?
      
      signature = generate_signature(data, algorithm, signature_key)
      "sender=#{merchant_pos_id};signature=#{};algorithm=#{algorithm};content=DOCUMENT"          
    end

    def generate_signature(data, algorithm, signature_key)
      data = data + signature_key
      if algorithm == "MD5"
        signature = Digest::MD5.digest(data)
      elsif ['SHA', 'SHA1', 'SHA-1'].include? algorithm
        signature = Digest::SHA1.hexdigest data
        algorithm = "SHA-1"
      elsif ['SHA-256', 'SHA256', 'SHA_256'].include? algorithm
        signature = Digest::SHA256.hexdigest data
        algorithm = "SHA-256"
      else
        signature = ""
      end
      signature
    end

    def parse_signature(data)
      parameters = {}
      data.split(";").each do |parameter|
        k,v = parameter.split("=")
        parameters[k] = v
      end
      parameters
    end

    def verify_signature(message, algorithm, signature, signature_key)
      generate_signature(message, algorithm, signature_key) == signature
    end

  end

end