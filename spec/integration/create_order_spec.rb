require "spec_helper"

describe "Create an order" do
  it "should create a valid order" do
    OpenPayU::Configuration.configure do |config|
        config.env              = "sandbox"
        config.merchant_pos_id  = "38050"
        config.pos_auth_key     = "L5eY9WI"
        config.client_id        = "38050"
        config.client_secret    = "1fa2257ee1d7e5c7f7f196772645c5e5"
        config.signature_key    = "fbd13a1c1fbfb226fcc3d3f8be4aeb53"
        config.my_url           = "http://local.citeam.pl"
        config.oauth_access     = "/transakcje/oauth_access"
        config.notify_url       = "/transakcje/payu_report"
        config.cancel_url       = "/transakcje/error"
        config.success_url      = "/transakcje/success"
        config.service_domain   = "payu.pl"
      end
  end
end 