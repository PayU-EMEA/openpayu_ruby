# -*- encoding : utf-8 -*-
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'rubygems'
require 'openpayu'
require 'test_objects/order'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir                    = 'spec/cassettes'
  c.hook_into                               :fakeweb
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.before(:all) do
    OpenPayU::Configuration.configure do |cfg|
      cfg.env              = 'secure'
      cfg.merchant_pos_id  = '145227'
      cfg.signature_key    = '13a980d4f851f3d9a1cfc792fb1f5e50'
      cfg.algorithm        = 'MD5'
      cfg.service_domain   = 'payu.com'
      cfg.protocol         = 'https'
      cfg.data_format      = 'json'
    end
  end
end
