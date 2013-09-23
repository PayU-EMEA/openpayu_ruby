require "spec_helper"

describe OpenPayU::Token do
   before do
    OpenPayU::Configuration.configure do |config|
        config.env              = "secure"
        config.merchant_pos_id  = "145227"
        config.pos_auth_key     = "L5eY9WI"
        config.client_id        = "145227"
        config.client_secret    = "1fa2257ee1d7e5c7f7f196772645c5e5"
        config.signature_key    = "13a980d4f851f3d9a1cfc792fb1f5e50"
        config.my_url           = "http://local.citeam.pl"
        config.oauth_access     = "/transakcje/oauth_access"
        config.notify_url       = "/transakcje/payu_report"
        config.cancel_url       = "/transakcje/error"
        config.success_url      = "/transakcje/success"
        config.service_domain   = "payu.com"
      end
  end

it "should create token" do
token = {card: {number: "5337370000040899", expiration_month: 8, expiration_year: 2014 }}
OpenPayU::Token.create(token)
end
  
end