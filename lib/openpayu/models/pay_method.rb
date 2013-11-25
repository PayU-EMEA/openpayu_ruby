# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class PayMethod < Model
      attr_accessor :type, :value, :ext_pay_method_id, :amount, :currency_code
      validates :type, presence: true
      has_one_object :card
    end
  end
end
