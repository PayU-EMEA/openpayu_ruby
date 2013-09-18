module OpenPayU
  module Models
    class Order
      attr_accessor :customer_ip, :ext_order_id, :merchant_pos_id, :description, :currency_code, :total_amount, :validity_time,
        :notify_url, :order_url
      #has_one :buyer not required
      #has_one :fee not required
      #has_one :pay_method not required
      #has_many :products 
      #has_many :shipping_methods
    end
  end
end