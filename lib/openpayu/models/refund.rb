module OpenPayU
  module Models
    class Refund < Model
       attr_accessor :order_id, :ext_refund_id, :type, :amount, :commission_amount, :proxy_commision_amount, :currency_code, :description, :bank_description, :source_account_number
       validates :description, :order_id, presence: true
    end
  end
end