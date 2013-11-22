require 'net/http'
require 'net/https'
require 'uri'

module OpenPayU

  class Connection

    def self.post(url, data, headers)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true if OpenPayU::Configuration.use_ssl?
      request = Net::HTTP::Post.new(uri.path)
      request.body = data
      request["Content-Type"] = "application/#{OpenPayU::Configuration.data_format}"
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      response = http.request(request)
      {response: response, request: request}
    end

    def self.put(url, data, headers)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true if OpenPayU::Configuration.use_ssl?
      request = Net::HTTP::Put.new(uri.path)
      request.body = data
      request["Content-Type"] = "application/#{OpenPayU::Configuration.data_format}"
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      response = http.request(request)
      {response: response, request: request}
    end

    def self.get(url, data, headers)
      self.common_connection(url, data, headers, "GET")
    end

    def self.delete(url, data, headers)
      self.common_connection(url, data, headers, "DELETE")
    end

    private

    def self.common_connection(url, data, headers, method)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if OpenPayU::Configuration.use_ssl?
      request = if method == "DELETE"
        Net::HTTP::Delete.new(uri.request_uri, headers)
      else
        Net::HTTP::Get.new(uri.request_uri, headers)
      end
      request["Content-Type"] = "application/#{OpenPayU::Configuration.data_format}"
      request["OpenPayu-Signature"] = headers["OpenPayu-Signature"]
      response = http.request(request)
      {response: response, request: request}
    end

  end

end