module OpenPayU
  module Models
    class Token < Model
      attr_accessor :type, :customer_id, :email, :first_name, :last_name
      # validates :number, :expiration_month, :expiration_year, presence: true

      has_one_object :card
    end
  end
end