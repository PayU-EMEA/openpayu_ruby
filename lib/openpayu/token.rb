module OpenPayU

  # Create Token

  class Token

    # dasadas
    #
    # @param [Hash] form_fields Hash with all form fields with values
    # @param [String] signature_key defaults to {OpenPayU::Configuration.signature_key}
    # @param [String] algorithm defaults to {OpenPayU::Configuration.algorithm}
    # @param [String] merchant_pos_id defaults to {OpenPayU::Configuration.merchant_pos_id}
    # @return [String] Signature that should be inserted to field with name "OpenPayu-Signature"    
    def self.create(data)
      raise NotImplementedException, "This feature is not yet implemented"
      url = Configuration.get_base_url + "token." + OpenPayU::Configuration.data_format
      token = Models::Token.new(data)
      request = Documents::Request.new(token.prepare_data("TokenCreateRequest"))
      OpenPayU::Documents::Response.new(
        Connection.post(url, request.data, request.header), "TokenCreateResponse"
      )
    end

  
  end
end