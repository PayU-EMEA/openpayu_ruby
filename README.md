[![Code Climate](https://codeclimate.com/repos/524eb044f3ea00329815dff1/badges/885c2d52f25c02295344/gpa.png)](https://codeclimate.com/repos/524eb044f3ea00329815dff1/feed)

# OpenPayU Ruby

The OpenPayU Ruby library provides integration access to the PayU Gateway API ver. 2.

## Installation

Add this line to your application's Gemfile:

    gem 'openpayu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openpayu

##Configure Gem
  To configure OpenPayU environment add a file to config/initializers/openpayu.rb containing:

    OpenPayU::Configuration.configure do |config|
        config.merchant_pos_id  = '145227'
        config.signature_key    = '13a980d4f851f3d9a1cfc792fb1f5e50'
        config.algorithm        = 'MD5' # MD5, SHA-1, SHA-256
        config.service_domain   = 'payu.com'
        config.protocol         = 'https'
        config.data_format      = 'json' # json, xml
        config.env              = 'secure'
        config.order_url        = 'http://localhost/order'
        config.notify_url       = 'http://localhost/notify'
        config.continue_url     = 'http://localhost/success'
    end

  Or by providing a path to YAML file

    OpenPayU::Configuration.configure File.join(Rails.root, 'config/openpayu.yml')

  Structure of YAML file:

    development:
      merchant_pos_id: '145227'
      signature_key: 13a980d4f851f3d9a1cfc792fb1f5e50
      algorithm: MD5 # MD5, SHA-1, SHA-256
      service_domain: payu.com
      protocol: https
      data_format: json # json, xml
      env: secure
      order_url: http://localhost/order
      notify_url: http://localhost/notify
      continue_url: http://localhost/success
    production:
      merchant_pos_id: '145227'
      signature_key: 13a980d4f851f3d9a1cfc792fb1f5e50
      algorithm: MD5 # MD5, SHA-1, SHA-256
      service_domain: payu.com
      protocol: https
      data_format: json # json, xml
      env: secure
      order_url: http://localhost/order
      notify_url: http://localhost/notify
      continue_url: http://localhost/success

##Usage

###Creating Transparent order
  For more information about order please refer to: http://developers.payu.com/pl/restapi.html#payusdk_creating_new_order_api
  To create an order you must provide a Hash with order:

    order = {
      merchant_pos_id: "145227",
      customer_ip: "127.0.0.1", # You can user request.remote_ip in your controller
      ext_order_id: 1342, #Order id in your system
      order_url: "http://localhost/",
      description: "New order",
      currency_code: "PLN",
      total_amount: 10000,
      notify_url: "http://localhost/",
      continue_url: "http://localhost/",
      buyer: {
        email: 'dd@ddd.pl',
        phone: '123123123',
        first_name: 'Jan',
        last_name: 'Kowalski',
        language: 'pl_PL',
        delivery: {
          street: 'street',
          postal_code: 'postal_code',
          city: 'city',
          country_code: 'PL'
        }
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
      ],
      shipping_method: {
        country: 'PL',
        price: 'price',
        name: 'shipping name'
      }
    }

  When you have ready order Hash you can create new order:

    @response = OpenPayU::Order.create(order)

  If request succeed to create it will return "COMPLETE" as a status_code.
  There might be also a redirect to page with confirmation.
  There are three redirect types:

  * WARNING_CONTINUE_REDIRECT
  * WARNING_CONTINUE_CVV
  * WARNING_CONTINUE_3DS

```
case @response.status["status_code"]
when 'COMPLETE'
  # order has been created
when /WARNING_CONTINUE_/
  #need to redirec user to a provided URL
  redirect_to @response.redirect_uri
else
  #in other cases something went wrong
  logger.info "Unable to create order. 
    Status: #{@response.status["status_code"]}.
    Response: #{@response}"
end
```

###Creating Hosted order

  If you pass the same Hash of order as above to hosted_order_form you will
  get a String containgin a form to embed in your view

    #in your controller
    @order_form_data = OpenPayU.hosted_order_form(order)

    # in your view
    <%= @order_form_data.html_safe %>

###Retrieving order from OpenPayU
  You can retrieve order by its PayU order_id

    @response = OpenPayU::Order.retrieve("Z963D5JQR2230925GUEST000P01")

###Cancelling order 
  You can cancel order by its PayU order_id

    @response = OpenPayU::Order.cancel("Z963D5JQR2230925GUEST000P01")

###Updating order status
  You can update order status to accept order when Autoreceive in POS is turned off

    status_update = {
            order_id: "Z963D5JQR2230925GUEST000P01",
            order_status: 'COMPLETED'
          }
    @response = OpenPayU::Order.status_update(status_update)

###Handling notifications from PayU
  PayU sends requests to your application when order status changes

    @response = OpenPayU::Order.consume_notification(request) #request object from controller
    @response.order_status #NEW PENDING CANCELLED REJECTED COMPLETED WAITING_FOR_CONFIRMATION
    #you should response to PayU with special structure (OrderNotifyResponse)
    render json: OpenPayU::Order.build_notify_response(@response.req_id)


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
