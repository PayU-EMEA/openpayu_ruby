module OpenPayU
  module Models
    class Product
      attr_accessor :country, :price, :nazwa
      validates :country, :price, :nazwa, presence: true
    end
  end
end