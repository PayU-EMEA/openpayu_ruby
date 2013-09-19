module OpenPayU
  module Models
    class Order < Model
      attr_accessor :customer_ip, :ext_order_id, :merchant_pos_id, :description, :currency_code, :total_amount, :validity_time,
        :notify_url, :order_url
      validates :customer_ip, :ext_order_id, :merchant_pos_id, :description, :currency_code, :total_amount, presence: true
      has_one_object :buyer #not required
      has_one_object :fee #not required
      has_one_object :pay_method #not required
      has_many_objects :products, :product #not required
      has_many_objects :shipping_methods, :shipping_methods #not required

    end
  end
end