module OpenPayU
  module Models
    class Buyer::Delivery
      includes OpenPayU::Models::Address
      attr_accessor :TIN, :e_invoice_requested
    end
  end
end