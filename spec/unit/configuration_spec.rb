require "spec_helper.rb"

describe OpenPayU::Configuration do
  context "valid configuration" do
    before(:all) do
      OpenPayU::Configuration.configure do |config|
        config.env              = "sandbox"
        config.signature_key    = "fsd8931231232e4aeb53"
        config.service_domain   = "payu.pl"
      end
    end

    it { OpenPayU::Configuration.valid?.should be_true }
    it { OpenPayU::Configuration.env.should eq "sandbox" }
    it { OpenPayU::Configuration.service_domain.should eq "payu.pl" }

    it "should override default" do
      OpenPayU::Configuration.env.should eq "sandbox"
    end

    it "should set default value" do
      OpenPayU::Configuration.country.should eq "pl"
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
          config.signature_key    = "fsd8931231232e4aeb53"
          config.service_domain   = "payu.pl"
        end.to(
          raise_error(WrongConfigurationError, "Parameter 'merchant_pos_id' is invalid.")
        )
      end
    end
  end

end
