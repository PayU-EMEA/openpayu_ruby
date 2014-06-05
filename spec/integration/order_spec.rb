# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Create transparent order' do
  context "run with data format #{OpenPayU::Configuration.data_format}" do
    before(:all) do
      order = TestObject::Order.valid_order
      VCR.use_cassette('create_order') do
        @response = OpenPayU::Order.create(order)
      end
    end
    context 'create order' do

      it { @response.response.code.should eq '200' }
      it { @response.status['status_code'].should eq 'SUCCESS' }
      it { @response.order_id.should_not be_empty }
    end
    context 'Retrieve order' do
      before(:all) do
        VCR.use_cassette('retrieve_order') do
          @response = OpenPayU::Order.retrieve("MHQ3MRZKSQ140528GUEST000P01")
        end
      end
      it { @response.response.code.should eq '200' }
      it { @response.status['status_code'].should eq 'SUCCESS' }
      it { @response.orders.should_not be_empty }
    end

    context 'Consume order notification' do
      it do
        body = TestObject::Order.notification_request.to_json
        request = OpenPayU::Documents::Request.new(body)
        @request = OpenPayU::Order.consume_notification(request)
        @request.order.should_not be_empty 
      end
    end

    # context 'refund order' do
    #   before(:all) do
    #     # VCR.use_cassette('refund_order') do
    #       @refund = OpenPayU::Refund.create({
    #         order_id: 'VQWQ6XMVKR140415GUEST000P01',
    #         description: 'Money refund'
    #         })
    #     # end
    #   end
    #   it { @refund.response.code.should eq '200' }
    #   it { @refund.status['status_code'].should eq 'SUCCESS' }
    #   it { @refund.order_id.should eq @response.order_id }
    #   it { @refund.refund['status'].should eq 'INIT' }
    # end

    context 'update order' do
      before(:all) do
        status_update = {
          order_id: "NJZFFJ82D2140528GUEST000P01",
          order_status: 'COMPLETED'
        }
        VCR.use_cassette('update_order') do
          @response = OpenPayU::Order.status_update(status_update)
        end
      end
      it { @response.response.code.should eq '200' }
      it { @response.status['status_code'].should eq 'SUCCESS' }
      it { @response.status['status_desc'].should eq 'Status was updated' }
    end

    context 'cancel order' do
      before(:all) do
        VCR.use_cassette('cancel_order') do
          @response = OpenPayU::Order.cancel('VQWQ6XMVKR140415GUEST000P01')
        end
      end
      it { @response.response.code.should eq '200' }
      it { @response.status['status_code'].should eq 'SUCCESS' }
    end

    describe ' Generate OrderNotifyResponse' do
      it do
        OpenPayU::Order.build_notify_response(3_243_243_324_342)
        .should include('SUCCESS')
      end
    end

  end
end

describe 'Create hosted order' do

end
