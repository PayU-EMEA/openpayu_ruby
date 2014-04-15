# -*- encoding : utf-8 -*-
require 'digest'

module OpenPayU

  class Document

    def generate_signature_structure(data, algorithm, pos_id = '', key = '')
      if key.empty?
        raise WrongConfigurationError,
              'Merchant Signature Key (signature_key)
              should not be null or empty.'
      end
      raise WrongConfigurationError,
            'Merchant Pos Id (merchant_pos_id) should
            not be null or empty.' if pos_id.blank?
      signature = generate_signature(data, algorithm, key)
      "sender=#{pos_id};signature=#{signature};algorithm=#{algorithm}"
    end

    def generate_signature(data, algorithm, signature_key)
      data = data + signature_key.to_s
      if algorithm == 'MD5'
        signature = Digest::MD5.hexdigest(data)
      elsif %w(SHA SHA1 SHA-1).include? algorithm
        signature = Digest::SHA1.hexdigest data
      elsif %w(SHA-256 SHA256 SHA_256).include? algorithm
        signature = Digest::SHA256.hexdigest data
      else
        signature = ''
      end
      signature
    end

    def verify_response
      unless @response
        raise EmptyResponseError,
              "Got empty response from request: #{@request.try(:body)}"
      end
      if ( response.is_a?(OpenPayU::Documents::Request) ||
        %w(200 201 422 302).include?(response.code)) 
          # verify_signature(@body)
        true
      else
        raise HttpStatusException,
              "Invalid HTTP response code (#{@response.code}).
              Response body: #{@body}."
      end
    end

    def verify_signature(message)
      signature = parse_signature
      generated_signature = generate_signature(
        message,
        signature['algorithm'],
        OpenPayU::Configuration.signature_key
      )
      if generated_signature == signature['signature']
        true
      else
        raise WrongSignatureException,
              "Invalid signature: Got message signed with:
              #{signature["signature"]}. Generated signature:
              #{generated_signature}"
      end

    end

    def parse_signature
      parameters = {}
      get_signature.split(';').each do |parameter|
        k, v = parameter.split('=')
        parameters[k] = v
      end
      parameters
    end

    def get_signature
      @response['X-OpenPayU-Signature'] ||
      @response['x-openpayu-signature'] ||
      @response['openpayu-signature'] ||
      @response.headers['x-openpayu-signature'] ||
      @response.headers['openpayu-signature']
    end

    def underscore_keys(hash)
      deep_transform_keys(hash) { |key| key.underscore }
    end

    def deep_transform_keys(hash, &block)
      result = {}
      hash.each do |key, value|
        result[yield(key)] =
          if value.is_a?(Hash)
            deep_transform_keys(value, &block)
          else
            value
          end
      end
      result
    end

  end

end
