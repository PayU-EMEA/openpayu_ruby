module  TestObject
  class Order


    def self.valid_order
      {
        merchant_pos_id: OpenPayU::Configuration.merchant_pos_id,
        customer_ip: "127.0.0.1",
        ext_order_id: 1342,
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
            value: 'TOK_1HPPNU4HIOWT180pPDWhuhAmM3ym',
          }
        ]
      }
    end

    def self.order_status_request(order_id)
      {
        order_id: order_id,
        reason: "Test Reject",
        order_creation_date: Time.now,
        order_status: "CANCELLED"
      }
    end

    def self.notification_request
      {
        "OpenPayU"=> {
          "OrderNotifyRequest"=> {
            "Order"=> {
              "ExtOrderId"=> "extOrderId",
              "Description"=> "product no. 1",
              "Products"=> {
                "Product"=> [
                  {
                    "Name"=> "Product1",
                    "Quantity"=> "1",
                    "UnitPrice"=> "1000"
                  }, {
                    "Name"=> "Product2",
                    "Quantity"=> "3",
                    "UnitPrice"=> "9870"
                  }
                ]
              },
              "Buyer"=> {
                "Phone"=> "+48505606707",
                "Email"=> "testowy@mail.pl",
                "CustomerId"=> "guest",
                "FirstName"=> "Jan",
                "Language"=> "pl",
                "LastName"=> "Kowalski"
              },
              "OrderId"=> "JS2JMSQ68L130826GUEST000P01",
              "CurrencyCode"=> "PLN",
              "CustomerIp"=> "10.1.1.127",
              "Status"=> "COMPLETED",
              "NotifyUrl"=> "http=>//sklep.url/notify",
              "ValidityTime"=> "86400",
              "MerchantPosId"=> "122643",
              "PayMethod"=> {
                "Type"=> "PBL"
              },
              "OrderCreateDate"=> "2013-08-26T09=>51=>50.303+02=>00",
              "OrderUrl"=> "http=>//sklep.url/order",
              "TotalAmount"=> "1000"
            }
          }
        }
      }
    end
  end
end
