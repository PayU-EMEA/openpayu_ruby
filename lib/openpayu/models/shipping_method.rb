# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class ShippingMethod < Model
      attr_accessor :country, :price, :name
      validates :country, :price, :name, presence: true
    end
  end
end
