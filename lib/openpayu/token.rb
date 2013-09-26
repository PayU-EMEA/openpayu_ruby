module OpenPayU
  class Token

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