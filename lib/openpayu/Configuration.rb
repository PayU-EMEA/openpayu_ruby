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
                    :data_format,
                    :algorithm

      def configure
        set_defaults
        yield self
        valid?
      end

      def set_defaults
        @domain = "payu.com"
        @env    = "sandbox"
        @country = "pl"
        @data_format = "json"
        @algorithm = "MD5"
        @summary_path = "/standard/co/summary"
        @auth_path = "/standard/oauth/user/authorize"
        @oauth_token_by_code_path = "/standard/user/oauth/authorize"
        @oauth_token_by_cc_path = "/standard/oauth/authorize"
        @order_create_request_path = "/standard/co/openpayu/OrderCreateRequest" 
        @order_status_update_path = "/standard/co/openpayu/OrderStatusUpdateRequest" 
        @order_cancel_request_path = "/standard/co/openpayu/OrderCancelRequest" 
        @order_retrieve_request_path = "/standard/co/openpayu/OrderRetrieveRequest" 
      end


      def set_defaults_for_test
        @env              = "secure"
        @merchant_pos_id  = "145227"
        @pos_auth_key     = "sM4NhBj"
        @client_id        = "145227"
        @client_secret    = "13a980d4f851f3d9a1cfc792fb1f5e50"
        @signature_key    = "13a980d4f851f3d9a1cfc792fb1f5e50"
        @my_url           = "http://local.citeam.pl"
        @oauth_access     = "/transakcje/oauth_access"
        @notify_url       = "/transakcje/payu_report"
        @cancel_url       = "/transakcje/error"
        @success_url      = "/transakcje/success"
        @service_domain   = "payu.com"
        @domain = "payu.com"
        @country = "pl"
        @data_format = "json"
        @algorithm = "MD5"
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