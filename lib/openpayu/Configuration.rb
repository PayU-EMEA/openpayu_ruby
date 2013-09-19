require 'singleton'

module OpenPayU

  class Configuration

    include Singleton

    class << self
      attr_accessor :env, 
                    :merchant_pos_id, 
                    :pos_auth_key, 
                    :client_id, 
                    :client_secret, 
                    :signature_key, 
                    :my_url, 
                    :notify_url, 
                    :cancel_url, 
                    :success_url, 
                    :shipping_cost_url, 
                    :oauth_access,
                    :service_url, 
                    :summary_path, 
                    :auth_url, 
                    :service_domain, 
                    :my_url, 
                    :country, 
                    :oauth_token_by_code_path, 
                    :oauth_token_by_cc_path, 
                    :order_create_request_path, 
                    :order_status_update_path, 
                    :order_cancel_request_path, 
                    :order_retrieve_request_path,
                    :data_format

      def configure
        set_defaults
        yield self
        valid?
      end

      def set_defaults
        @domain = "payu.com"
        @env    = "sandbox"
        @country = "pl"
        @summary_path = "/standard/co/summary"
        @auth_path = "/standard/oauth/user/authorize"
        @oauth_token_by_code_path = "/standard/user/oauth/authorize"
        @oauth_token_by_cc_path = "/standard/oauth/authorize"
        @order_create_request_path = "/standard/co/openpayu/OrderCreateRequest" 
        @order_status_update_path = "/standard/co/openpayu/OrderStatusUpdateRequest" 
        @order_cancel_request_path = "/standard/co/openpayu/OrderCancelRequest" 
        @order_retrieve_request_path = "/standard/co/openpayu/OrderRetrieveRequest" 
      end

      def required_parameters
        [:merchant_pos_id, :pos_auth_key, :client_id, :client_secret, :signature_key]
      end

      def valid?
        required_parameters.each do |parameter|
          raise WrongConfigurationError, "Parameter '#{parameter}' is invalid." if send(parameter).empty?
        end
        true
      end

      def get_base_url
        "https://#{@env}.#{@domain}/api/v2/"
      end
    end
  end

end