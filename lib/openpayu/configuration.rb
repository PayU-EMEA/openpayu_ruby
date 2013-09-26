require 'singleton'

module OpenPayU

  class Configuration

    include Singleton

    class << self
      attr_accessor :env, :merchant_pos_id, :pos_auth_key, :client_id, :client_secret, :signature_key,
         :service_domain, :country, :data_format, :algorithm, :protocol

      def configure
        set_defaults
        yield self
        valid?
      end

      def set_defaults
        @service_domain = "payu.com"
        @env    = "sandbox"
        @country = "pl"
        @algorithm = "MD5"
      end

      def required_parameters
        [:merchant_pos_id, :signature_key]
      end

      def valid?
        required_parameters.each do |parameter|
          raise WrongConfigurationError, "Parameter '#{parameter}' is invalid." if send(parameter).nil? || send(parameter).blank?
        end
        true
      end

      def get_base_url
        "#{@protocol}://#{@env}.#{@service_domain}/api/v2/"
      end

      def use_ssl?
        @protocol == "https"
      end
    end
  end

end
