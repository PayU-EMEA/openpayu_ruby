module OpenPayU
  module Models
    class PayMethod
      attr_accessor :type, :value, :ext_pay_method_id, :amount, :currency_code
      validates :type, presence: true
      #has_one :card not required
    end
  end
end