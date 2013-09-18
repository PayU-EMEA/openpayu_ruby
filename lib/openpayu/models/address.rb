module OpenPayU
  module Models
    class Address
      attr_accessor :street, :postal_box, :postal_code, :city, :state, :country_code, 
        :name, :recipient_name, :recipient_email, :recipient_phone
      validates :street, :postal_code, :city, :country_code, :recipient_name, presence: true
    end
  end
end