require "spec_helper.rb"

describe OpenPayU::Models::Order do
  context "create valid order" do
    let(:order) { OpenPayU::Models::Order.new(TestObject::Order.valid_order) }


    it { order.valid?.should be_true }
    it { order.all_objects_valid?.should be_true }
    it { order.merchant_pos_id.should eq "45654" }

    context "should create product objects" do
      before { order.products = [ { name: "Produkt 1" } ] }

      it { order.products.size.should eq 1 }
      it { order.products.first.class.name.should eq "OpenPayU::Models::Product" }
    end

    context "preaper correct Hash" do
      it do
        hash = order.prepare_keys
        hash.delete("ReqId")
        hash.should eq({"MerchantPosId"=>"45654", "CustomerIp"=>"127.0.0.1", "ExtOrderId"=>1342, "OrderUrl"=>"http://localhost/", "Description"=>"New order", "CurrencyCode"=>"PLN", "TotalAmount"=>10000, "NotifyUrl"=>"http://localhost/", "ContinueUrl"=>"http://localhost/", "ValidityTime"=>"48000", "Buyer"=>{"Email"=>"dd@ddd.pl", "Phone"=>"123123123", "FirstName"=>"Jan", "LastName"=>"Kowalski", "Language"=>"pl_PL", "NIN"=>"123456"}, "Products"=>[{"Product"=>{"Name"=>"Mouse", "UnitPrice"=>10000, "Quantity"=>1}}], "PayMethods"=>[{"PayMethod"=>{"Type"=>"CARD_TOKEN", "Value"=>"TOKC_WIPWVM13M7L0HTXS0YO2JPJ72HD"}}]})
      end
    end
  end

  context "create invalid order" do
    let(:order) do
      OpenPayU::Models::Order.new(
        {
          customer_ip: "127.0.0.1",
          ext_order_id: 1,
          description: "New order",
          currency_code: "PLN",
          total_amount: 1000,
          products:[{name: "dupa"}, {name: "dupa2"}]
        }
      )
    end
    it { order.valid?.should be_false }
    it { order.all_objects_valid?.should be_false }
  end

end
