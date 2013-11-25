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
      cfg.env              = 'platnosci-dev5'
      cfg.merchant_pos_id  = '45654'
      cfg.signature_key    = '981852826b1f62fb24e1771e878fb42d'
      cfg.algorithm        = 'MD5'
      cfg.service_domain   = 'dc2'
      cfg.protocol         = 'http'
      cfg.data_format      = 'json'
    end
  end
end
