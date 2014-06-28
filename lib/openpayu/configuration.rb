# -*- encoding : utf-8 -*-
require 'singleton'

module OpenPayU

  class Configuration

    include Singleton

    class << self
      attr_accessor :env, :merchant_pos_id, :pos_auth_key, :client_id,
        :client_secret, :signature_key, :service_domain, :country, :data_format,
          :algorithm, :protocol, :order_url, :notify_url, :complete_url

      def configure(file_path = nil)
        set_defaults
        if block_given?
          yield self
        else
          file = File.open(file_path) if file_path && File.exists?(file_path)
          env = defined?(Rails) ? Rails.env : ENV['RACK_ENV']
          config = YAML.load(file)[env]
          if config.present?
            config.each_pair do |key, value|
              send("#{key}=", value)
            end
          end
        end
        valid?
      end

      def set_defaults
        @service_domain = 'payu.com'
        @env    = 'sandbox'
        @country = 'pl'
        @algorithm = 'MD5'
        @data_format = 'json'
      end

      def required_parameters
        [:merchant_pos_id, :signature_key]
      end

      def valid?
        required_parameters.each do |parameter|
          if send(parameter).nil? || send(parameter).blank?
            raise WrongConfigurationError, "Parameter #{parameter} is invalid."
          end
        end
        true
      end

      def get_base_url
        "#{@protocol}://#{@env}.#{@service_domain}/api/v2/"
      end

      def use_ssl?
        @protocol == 'https'
      end
    end
  end

end
