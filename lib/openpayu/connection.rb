require 'net/http'
require 'net/https'
require 'uri'



module OpenPayU
  class Connection

    def self.post(url, data, headers)
      p "Post to #{url}"
      p "with data to #{data}"
      p "headers #{headers.inspect}"

      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true if OpenPayU::Configuration.use_ssl?
      request = Net::HTTP::Post.new(uri.path)
      request.body = data
      request["Content-Type"] = "application/#{OpenPayU::Configuration.data_format}"
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      response = http.request(request)
      p response.body

      {response: response, request: request}
    end

    def self.get(url, data, headers)
      p "get from #{url}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if OpenPayU::Configuration.use_ssl?
      p "headers #{headers.inspect}"
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      request["Content-Type"] = "application/#{OpenPayU::Configuration.data_format}"
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]

      response = http.request(request)
      p response.body
      {response: response, request: request}
      
    end

    def self.delete(url, data, headers)
      p "Delete from #{url}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if OpenPayU::Configuration.use_ssl?
      p "headers #{headers.inspect}"
      request = Net::HTTP::Delete.new(uri.request_uri, headers)
      request["Content-Type"] = "application/#{OpenPayU::Configuration.data_format}"
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      p request.inspect

      response = http.request(request)
      p response.body 
      {response: response, request: request}

    end

  end
end