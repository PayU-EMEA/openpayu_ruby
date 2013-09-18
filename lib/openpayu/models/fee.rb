module OpenPayU
  module Models
    class Fee
      attr_accessor :amount, :description, :type
      validates :amount, presence: true
    end
  end
end