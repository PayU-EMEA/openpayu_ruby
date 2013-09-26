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
        config.client_id        = "45654"
        config.client_secret    = "65fe8d2f60e2bc37ddb9ad7ba2f681fa"
        config.signature_key    = "981852826b1f62fb24e1771e878fb42d"
        config.my_url           = "http://local.citeam.pl"
        config.notify_url       = "/transakcje/payu_report"
        config.cancel_url       = "/transakcje/error"
        config.success_url      = "/transakcje/success"
        config.algorithm        = "MD5"
        config.service_domain   = "dc2"
        config.protocol         = "http"
        config.data_format      = "json"
    end
  end
end