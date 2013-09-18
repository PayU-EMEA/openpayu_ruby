module OpenPayU
  module Models
    class Refund
       attr_accessor :ext_refund_id, :type, :amount, :commission_amount, :proxy_commision_amount, :currency_code, :description, :bank_description, :source_account_number
       validate :description, presence: true
    end
  end
end