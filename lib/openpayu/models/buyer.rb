module OpenPayU
  module Models
    class Buyer < Model
      attr_accessor :email, :phone, :first_name, :last_name, :language, :NIN
      validates :email, :phone, :first_name, :last_name, presence: true
      has_one_object :delivery #not required
      has_one_object :invoice  #not required
    end
  end
end