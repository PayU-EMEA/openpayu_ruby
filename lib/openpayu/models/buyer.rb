module OpenPayU
  module Models
    class Buyer
      attr_accessor :email, :phone, :first_name, :last_name
      validates :email, :phone, :first_name, :last_name, presence: true
      #has_one :delivery not required
      #has_one :invoice not required
    end
  end
end