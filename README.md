[![Code Climate](https://codeclimate.com/repos/5244470a56b10276f501aaee/badges/82eaa372e10d503831cd/gpa.png)](https://codeclimate.com/repos/5244470a56b10276f501aaee/feed)
[![Build Status](https://magnum.travis-ci.com/streflik/openpayu_ruby_sdk.png?token=sqp5QvsmzqEqtVB3sNsK&branch=order)](https://magnum.travis-ci.com/streflik/openpayu_ruby_sdk)
# OpenpayuSdkRuby

The OpenPayU Ruby library provides integration access to the PayU Gateway API ver. 2.

## Installation

Add this line to your application's Gemfile:

    gem 'openpayu_sdk_ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openpayu_sdk_ruby

## Usage

###Configure Gem
  To configure OpenPayU environment add a file to config/initializers/openpayu.rb containing:

    OpenPayU::Configuration.configure do |config|
        config.merchant_pos_id  = "8389534"
        config.signature_key    = "95873498573498573897fb42d"
        config.algorithm        = "MD5" # MD5, SHA-1, SHA-256
        config.service_domain   = "payu.com"
        config.protocol         = "https"
        config.data_format      = "json" # json, xml
    end

###Creating new order
  To create an order you must provide a Hash with order:

    order = {
      merchant_pos_id: "8389534",
      customer_ip: "127.0.0.1", # You can user request.remote_ip in your controller
      ext_order_id: 1342, #Order id in your system
      order_url: "http://localhost/",
      description: "New order",
      currency_code: "PLN",
      total_amount: 10000,
      notify_url: "http://localhost/",
      continue_url: "http://localhost/",
      validity_time: '48000',
      buyer: {
        email: 'dd@ddd.pl',
        phone: '123123123',
        first_name: 'Jan',
        last_name: 'Kowalski',
        language: 'pl_PL',
        NIN: "123456"
      },
      products: [
        {
          name: 'Mouse',
          unit_price: 10000,
          quantity: 1
        }
      ],
      pay_methods: [
        {
          type: 'CARD_TOKEN',
          value: 'Token value'
        }
      ]
    }

  Full description of the Order parameters you can find here
  When you have ready order Hash you can create new order:

    @response = OpenPayU::Order.create(order)

###Retrieving order from OpenPayU
  You can retrieve order by its PayU order_id


    @response = OpenPayU::Order.retrieve("Z963D5JQR2230925GUEST000P01")


###Refund money


    @refund = OpenPayU::Refund.create({
      order_id: "Z963D5JQR2230925GUEST000P01", #required
      description: "Money refund", #required
      ext_refund_id: 21312, #Refund Id in your syste, optional
      amount: 1000, #If not provided, returns whole transaction, optional
      commission_amount: 123, #optional
      currency_code: "PLN" #optional
    })
    




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
