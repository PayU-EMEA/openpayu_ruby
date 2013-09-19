module OpenPayU
  module Models
    class ShippingMethod < Model
      attr_accessor :country, :price, :nazwa
      validates :country, :price, :nazwa, presence: true
    end
  end
end