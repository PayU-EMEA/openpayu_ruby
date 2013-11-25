# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class Fee < Model
      attr_accessor :amount, :description, :type
      validates :amount, presence: true
    end
  end
end
