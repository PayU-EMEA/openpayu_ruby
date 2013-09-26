require 'singleton'

module OpenPayU

  class Configuration

    include Singleton

    class << self
      attr_accessor :env, :merchant_pos_id, :pos_auth_key, :client_id, :client_secret, :signature_key,
        :my_url, :notify_url, :cancel_url, :success_url, :shipping_cost_url, :service_url, :summary_path,
        :auth_url, :service_domain, :my_url, :country, :data_format, :algorithm, :protocol

      def configure
        set_defaults
        yield self
        valid?
      end

      def set_defaults
        @domain = "payu.com"
        @env    = "sandbox"
        @country = "pl"
        @algorithm = "MD5"
        @summary_path = "/standard/co/summary"
      end

      def required_parameters
        [:merchant_pos_id, :client_id, :signature_key]
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
