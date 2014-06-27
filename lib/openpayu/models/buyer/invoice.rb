# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class Buyer::Invoice < Address
      attr_accessor :TIN, :e_invoice_requested
    end
  end
end
