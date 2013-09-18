require "spec_helper.rb"

describe OpenPayU::Configuration do 
  context "valid configuration" do
    before do
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

    it { OpenPayU::Configuration.valid?.should be_true }
    it { OpenPayU::Configuration.env.should eq "sandbox" }
    it { OpenPayU::Configuration.service_domain.should eq "payu.pl" }

    it "should override default" do 
      OpenPayU::Configuration.cancel_url.should eq "/transakcje/error"
    end

    it "should set default value" do 
      OpenPayU::Configuration.oauth_token_by_code_path.should eq "/standard/user/oauth/authorize"
    end

    context "change configuration to be invalid" do
      before { OpenPayU::Configuration.merchant_pos_id = "" }

      it "should raise exception" do
        expect { OpenPayU::Configuration.valid? }.to(
          raise_error(WrongConfigurationError, "Parameter 'merchant_pos_id' is invalid.")
        )
      end
    end
  end

  context "Invalid configuration" do
    it "should raise exeption when tried to set invalid configuration" do
      expect do
        OpenPayU::Configuration.configure do |config|
          config.env              = "sandbox"
          config.client_id        = "38050"
          config.client_secret    = "1fa2257ee1d7e5c7f7f196772645c5e5"
          config.signature_key    = "fbd13a1c1fbfb226fcc3d3f8be4aeb53"
          config.my_url           = "http://local.citeam.pl"
          config.oauth_access     = "/transakcje/oauth_access"
          config.notify_url       = "/transakcje/payu_report"
          config.cancel_url       = "/transakcje/error"
          config.success_url      = "/transakcje/success"
          config.service_domain   = "payu.pl"
        end.to(
            raise_error(WrongConfigurationError, "Parameter 'merchant_pos_id' is invalid.")
          )
      end
    end
  end
  
end