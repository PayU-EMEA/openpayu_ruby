module OpenPayU
  class Token

    def self.create(data)
        url = Configuration.get_base_url + "token." + OpenPayU::Configuration.data_format
        token = Models::Token.new(data)
        request = Documents::Request.new(token.prepare_data("TokenCreateRequest"))
        @response = OpenPayU::Documents::Response.new(
          Connection.post(url, request.data, request.header)
        )
    end

  
  end
end