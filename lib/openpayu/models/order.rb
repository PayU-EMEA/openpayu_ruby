module OpenPayU
  module Models
    class Order
      attr_accessor :customer_ip, :ext_order_id, :merchant_pos_id, :description, :currency_code, :total_amount
      #has_one :buyer not required
      #has_many :products 
      #has_many :shipping_methods
    end
  end
end