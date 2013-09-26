require "spec_helper"

describe "Create transparent order" do
  ["xml", "json"].each do |data_format|
    OpenPayU::Configuration.data_format = data_format
    context "run with data format #{OpenPayU::Configuration.data_format}" do
      before(:all) do
        order = TestObject::Order.valid_order
        VCR.use_cassette("create_order") do
          @response = OpenPayU::Order.create(order)
        end
      end
      context "create order" do
        it {@response.response.code.should eq "200" }
        it {@response.status["status_code"].should eq "SUCCESS" }
        it {@response.order_id.should_not be_empty }
      end
      context "Retrieve order" do
        before(:all) do
          VCR.use_cassette("retrieve_order") do
            @retrieve_response = OpenPayU::Order.retrieve(@response.order_id)
          end
        end
        it {@retrieve_response.response.code.should eq "200" }
        it {@retrieve_response.status["status_code"].should eq "SUCCESS" }
        it {@retrieve_response.orders.should_not be_empty }
        it {@retrieve_response.completed?.should be_true }
      end

      context "Consume order notification" do
        before(:all) do
          body = if OpenPayU::Configuration.data_format == "json"
            TestObject::Order.notification_request.to_json
          else
            TestObject::Order.notification_request["OpenPayU"].to_xml(root: "OpenPayU", skip_types: true, skip_instruct: true)
          end
          request = OpenPayU::Documents::Request.new(body)

          @request = OpenPayU::Order.consume_notification(request)
        end
        it {@request.order.should_not be_empty }
      end

      context "refund order" do
        before(:all) do

          VCR.use_cassette("refund_order") do
            @refund = OpenPayU::Refund.create({order_id: @response.order_id, description: "Money refund"})
          end
        end
        it {@refund.response.code.should eq "200" }
        it {@refund.status["status_code"].should eq "SUCCESS" }
        it {@refund.order_id.should eq @response.order_id }
        it {@refund.refund["status"].should eq "INIT" }
      end


      describe " Generate OrderNotifyResponse" do
        it { OpenPayU::Order.build_notify_response(3243243324342).should include("SUCCESS") }
      end

    end
  end
end

describe "Create hosted order" do

end
