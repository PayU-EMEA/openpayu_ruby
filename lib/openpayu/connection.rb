require 'net/http'
require 'net/https'
require 'uri'



module OpenPayU
  class Connection

    def self.post(url, data, headers)
      p "Post to #{url}"
      p "with data to #{data}"
      p "dheaders #{headers.inspect}"

      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      # https.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(uri.path)
      req.body = data
      req["Content-Type"] = "application/json"
      req["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      response = https.request(req)
         p response.body
      # p response.status

      [response, req]
    end

    def self.get(url, data, headers)
      p "get from #{url}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      p "headers #{headers.inspect}"
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      # request.body = data
      p request.inspect

      response = http.request(request)
      p response.body
      p response.status
      p response["header-here"] # All headers are lowercase
    end

    def self.delete(url, data, headers)
      p "Delete from #{url}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      p "headers #{headers.inspect}"
      request = Net::HTTP::Delete.new(uri.request_uri, headers)
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      # request.body = data
      p request.inspect

      response = http.request(request)
      p response.body 
      p response.status
      p response["header-here"] # All headers are lowercase
    end

  end
end