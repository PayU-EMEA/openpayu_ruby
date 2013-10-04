require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'rubygems'

require 'openpayu'
require "test_objects/order"
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.hook_into                :fakeweb
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
    config.before(:all) do
    OpenPayU::Configuration.configure do |config|
        config.env              = "platnosci-dev5"
        config.merchant_pos_id  = "45654"
        config.signature_key    = "981852826b1f62fb24e1771e878fb42d"
        config.algorithm        = "MD5"
        config.service_domain   = "dc2"
        config.protocol         = "http"
        config.data_format      = "json"
    end
  end
end