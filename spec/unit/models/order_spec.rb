require "spec_helper.rb"

describe OpenPayU::Models::Order do
  context "create valid order" do
    let(:order) do
      OpenPayU::Models::Order.new({
        merchant_pos_id: 4455,
        customer_ip: "127.0.0.1",
        ext_order_id: 1,
        description: "New order",
        currency_code: "PLN",
        total_amount: 1000
      })
    end
    it { order.valid?.should be_true }
    it { order.merchant_pos_id.should eq 4455 }
    
    context "should create product objects" do
      before { order.products = [ { name: "Produkt 1" } ] }

      it { order.products.size.should eq 1 }
      it { order.products.first.class.name.should eq "OpenPayU::Models::Product" } 
    end
  end

  context "create invalid order" do
    let(:order) do
      OpenPayU::Models::Order.new({
        customer_ip: "127.0.0.1",
        ext_order_id: 1,
        description: "New order",
        currency_code: "PLN",
        total_amount: 1000
      })
    end
    it { order.valid?.should be_false }
  end
  
end