# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class Card < Model
      attr_accessor :number, :expiration_month, :expiration_year, :CVV,
        :cardholder
      validates :number, :expiration_month, :expiration_year, presence: true
    end
  end
end
