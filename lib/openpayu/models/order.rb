# -*- encoding : utf-8 -*-
require 'securerandom'

module OpenPayU
  module Models
    class Order < Model
      STATUSES = %w(NEW PENDING CANCELLED REJECTED
                    COMPLETED WAITING_FOR_CONFIRMATION)
      attr_accessor :customer_ip, :ext_order_id, :merchant_pos_id, :description,
        :currency_code, :total_amount, :validity_time, :notify_url, :order_url,
          :continue_url, :req_id, :ref_req_id, :properties
      validates :customer_ip, :ext_order_id, :merchant_pos_id, :description,
        :currency_code, :total_amount, presence: true
      has_one_object :buyer # not required
      has_one_object :fee # not required
      has_one_object :pay_method # not required
      # has_many_objects :pay_methods, :pay_method # not required
      has_many_objects :products, :product # not required
      has_many_objects :shipping_methods, :shipping_method # not required

      def after_initialize
        @req_id       ||= "{#{SecureRandom.uuid}}"
        @notify_url   ||= OpenPayU::Configuration.notify_url
        @order_url    ||= OpenPayU::Configuration.order_url
        @continue_url ||= OpenPayU::Configuration.continue_url
      end
    end
  end
end
