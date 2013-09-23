require "spec_helper"

describe "Create an order" do
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
  it "should create a valid order" do
    # order = {
    #   merchant_pos_id: OpenPayU::Configuration.merchant_pos_id,
    #   customer_ip: "127.0.0.1", 
    #   ext_order_id: 1,
    #   description: "New order",
    #   currency_code: "PLN",
    #   total_amount: 1000,
    #   continue_url: "http://localhost/",
    #   validity_time: '48000',
    #   buyer: {
    #     email: 'dd@ddd.pl',
    #     phone: '123123123',
    #     first_name: 'Jaroslaw',
    #     last_name: 'Testowy',
    #     language: 'pl_PL',
    #     NIN: '123123123'
    #     },
    #   pay_methods: [{
    #     type: 'CARD_TOKEN',
    #     value: 'TOKC_WBHLQMQARHIVE5NNGYHQLY13K61'
    #   }],
    #   products: [
    #     {
    #       name: 'Mouse',
    #       unit_price: '10000',
    #       quantity: '1'
    #     }
    #   ]
    # }

    order = {
      merchant_pos_id: OpenPayU::Configuration.merchant_pos_id,
      customer_ip: "127.0.0.1", 
      # req_id: Digest::MD5.hexdigest(rand().to_s),
      # ref_req_id: "4324jk234h3j2k3j2",
      ext_order_id: 1,
      order_url: "http://localhost/",
      description: "New order",
      currency_code: "PLN",
      total_amount: 1000,
      notify_url: "http://localhost/",
      continue_url: "http://localhost/",
      validity_time: '48000',
      buyer: {
        email: 'dd@ddd.pl',
        phone: '123123123',
        first_name: 'Jaroslaw',
        last_name: 'Testowy',
        language: 'pl_PL',
        NIN: '123123123'
        },
      products: [
        {
          name: 'Mouse',
          unit_price: '10000',
          quantity: '1'
        }
      ]
    }
      
    response = OpenPayU::Order.create(order)
    response.status.should eq 200
  end

  it "should retrieve order" do
    OpenPayU::Order.retrieve(1234)
  end

end 