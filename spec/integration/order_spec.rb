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
      specify do
        expect(@response.response.code).to eq('200')
        expect(@response.status['status_code']).to eq('SUCCESS')
        expect(@response.order_id).not_to be_empty
      end
    end

    context 'Retrieve order' do
      before(:all) do
        VCR.use_cassette('retrieve_order') do
          @response = OpenPayU::Order.retrieve("MHQ3MRZKSQ140528GUEST000P01")
        end
      end
      specify do
        expect(@response.response.code).to eq('200')
        expect(@response.status['status_code']).to eq('SUCCESS')
        expect(@response.orders).not_to be_empty
      end
    end

    context 'Consume order notification' do
      specify do
        body = TestObject::Order.notification_request.to_json
        request = OpenPayU::Documents::Request.new(body)
        @request = OpenPayU::Order.consume_notification(request)
        expect(@request.order).not_to be_empty
      end
    end

    context 'refund order', broken: true do
      before(:all) do
        # VCR.use_cassette('refund_order') do
          @refund = OpenPayU::Refund.create({
            order_id: 'VQWQ6XMVKR140415GUEST000P01',
            description: 'Money refund'
            })
        # end
      end
      specify do
        expect(@refund.response.code).to eq('200')
        expect(@refund.status['status_code']).to eq('SUCCESS')
        expect(@refund.order_id).to eq(@response.order_id)
        expect(@refund.refund['status']).to eq('INIT')
      end
    end

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
      specify do
        expect(@response.response.code).to eq('200')
        expect(@response.status).to match(
          'code' => nil,
          'code_literal' => nil,
          'location' => a_value,
          'severity' => a_value,
          'status_code' => 'SUCCESS',
          'status_desc' => 'Status was updated'
        )
      end
    end

    context 'cancel order' do
      before(:all) do
        VCR.use_cassette('cancel_order') do
          @response = OpenPayU::Order.cancel('VQWQ6XMVKR140415GUEST000P01')
        end
      end
      specify do
        expect(@response.response.code).to eq('200')
        expect(@response.status).to match(
          'code' => a_value,
          'code_literal' => a_value,
          'location' => a_value,
          'severity' => a_value,
          'status_code' => 'SUCCESS',
          'status_desc' => a_value
        )
      end
    end

    describe 'Generate OrderNotifyResponse' do
      let(:response) { OpenPayU::Order.build_notify_response(3_243_243_324_342) }

      specify do
        expect(response).to include('SUCCESS')
      end
    end

  end
end

describe 'Create hosted order' do

end
