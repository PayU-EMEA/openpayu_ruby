# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class Token < Model
      attr_accessor :type, :customer_id, :email, :first_name, :last_name

      has_one_object :card
    end
  end
end
