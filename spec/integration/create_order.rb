require "spec_helper"

describe "Create an order" do
  it "should create a valid order" do
    OpenPayU::Configuration.configure do |config|
      config.env            = "sandbox"
      config.merchantPosId  = "38050"
      config.posAuthKey     = "L5eY9WI"
      config.clientId       = "38050"
      config.clientSecret   = "1fa2257ee1d7e5c7f7f196772645c5e5"
      config.signatureKey   = "fbd13a1c1fbfb226fcc3d3f8be4aeb53"
      config.myUrl          = "http://local.citeam.pl"
      config.oauth_access   = "/transakcje/oauth_access"
      config.notify_url     = "/transakcje/payu_report"
      config.cancel_url     = "/transakcje/error"
      config.success_url    = "/transakcje/success"
      config.domain         = "payu.pl"
    end
  end
end 