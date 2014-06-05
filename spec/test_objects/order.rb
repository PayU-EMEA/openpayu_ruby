# -*- encoding : utf-8 -*-
module  TestObject
  class Order

    def self.valid_order
      {
        merchant_pos_id: OpenPayU::Configuration.merchant_pos_id,
        customer_ip: '127.0.0.1',
        ext_order_id: 1342,
        order_url: 'http://localhost/',
        description: 'New order',
        currency_code: 'PLN',
        total_amount: 100,
        notify_url: 'http://localhost/',
        continue_url: 'http://localhost/',
        validity_time: '48000',
        buyer: {
          email: 'dd@ddd.pl',
          phone: '123123123',
          first_name: 'Jan',
          last_name: 'Kowalski'
          },
          products: [
            {
              name: 'Mouse',
              unit_price: 100,
              quantity: 1
            }
        ]
      }
    end

    def self.order_status_request(order_id)
      {
        order_id: order_id,
        reason: 'Test Reject',
        order_creation_date: Time.now,
        order_status: 'CANCELLED'
      }
    end

    def self.notification_request
      {
       "order"=>{
        "orderId"=>"LDLW5N7MF4140324GUEST000P01",
        "extOrderId"=>"ExtOrderId",
        "orderCreateDate"=>"2012-12-31T12=>00=>00",
        "notifyUrl"=>"http=>//tempuri.org/notify",
        "customerIp"=>"127.0.0.1",
        "merchantPosId"=>"{MerchantPosId}",
        "description"=>"My order description",
        "currencyCode"=>"PLN",
        "totalAmount"=>"200",
        "buyer"=>{
         "email"=>"john.doe@example.org",
         "phone"=>"111111111",
         "firstName"=>"John",
         "lastName"=>"Doe"
         },
         "products"=>{
           "products"=>{
            "name"=>"Product 1",
            "unitPrice"=>"200",
            "quantity"=>"1"
            }
          },
          "status"=>"COMPLETED"
        }
      }
    end
  end
end
