# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe OpenPayU::Configuration do

  context 'load from YAML' do
    before(:all) do
      ENV['RACK_ENV'] = 'test'
      OpenPayU::Configuration.configure 'spec/openpayu.yml'
    end
    let(:config) { OpenPayU::Configuration }

    specify do
      expect(config).to be_valid
      expect(config.merchant_pos_id).to eq('145227')
      expect(config.env).to eq('secure')
      expect(config.service_domain).to eq('payu.com')
    end
  end

  context 'valid configuration' do
    before(:all) do
      OpenPayU::Configuration.configure do |config|
        config.env              = 'sandbox'
        config.signature_key    = 'fsd8931231232e4aeb53'
        config.service_domain   = 'payu.pl'
      end
    end
    let(:config) { OpenPayU::Configuration }

    specify do
      expect(config).to be_valid
      expect(config.env).to eq('sandbox')
      expect(config.service_domain).to eq('payu.pl')
    end

    it 'should override default' do
      expect(config.env).to eq('sandbox')
    end

    it 'should set default value' do
      expect(config.country).to eq('pl')
    end

    context 'change configuration to be invalid' do
      before { OpenPayU::Configuration.merchant_pos_id = '' }

      it 'should raise exception' do
        expect { OpenPayU::Configuration.valid? }.to(
          raise_error(
            WrongConfigurationError,
            'Parameter merchant_pos_id is invalid.'
          )
        )
      end
    end
  end

  context 'Invalid configuration' do
    it 'should raise exeption when tried to set invalid configuration' do
      expect do
        OpenPayU::Configuration.configure do |config|
          config.env              = 'sandbox'
          config.signature_key    = 'fsd8931231232e4aeb53'
          config.service_domain   = 'payu.pl'
        end.to(
          raise_error(
            WrongConfigurationError,
            'Parameter merchant_pos_id is invalid.'
          )
        )
      end
    end
  end

end
