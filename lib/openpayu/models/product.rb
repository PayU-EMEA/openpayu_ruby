module OpenPayU
  module Models
    class Product
      attr_accessor :name, :unit_price, :quantity, :discount, :extra_info, :code, :version, :weight, :size
      validates :name, :unit_price, :quantity, presence: true
    end
  end
end