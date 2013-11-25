# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Create transparent order' do
  %w(json xml).each do |data_format|
    OpenPayU::Configuration.data_format = data_format
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
            @response = OpenPayU::Order.retrieve(@response.order_id)
          end
        end
        it { @response.response.code.should eq '200' }
        it { @response.status['status_code'].should eq 'SUCCESS' }
        it { @response.orders.should_not be_empty }
      end

      context 'Consume order notification' do
        before(:all) do
          body =
            if OpenPayU::Configuration.data_format == 'json'
              TestObject::Order.notification_request.to_json
            else
              TestObject::Order.notification_request['OpenPayU'].to_xml(
                root: 'OpenPayU',
                skip_types: true,
                skip_instruct: true
              )
            end
          request = OpenPayU::Documents::Request.new(body)
          @request = OpenPayU::Order.consume_notification(request)
        end
        it { @request.order.should_not be_empty }
      end

      context 'refund order' do
        before(:all) do
          VCR.use_cassette('refund_order') do
            @refund = OpenPayU::Refund.create({
              order_id: @response.order_id,
              description: 'Money refund'
            })
          end
        end
        it { @refund.response.code.should eq '200' }
        it { @refund.status['status_code'].should eq 'SUCCESS' }
        it { @refund.order_id.should eq @response.order_id }
        it { @refund.refund['status'].should eq 'INIT' }
      end

      context 'update order' do
        before(:all) do
          status_update = {
            order_id: @response.order_id,
            order_status: 'COMPLETED'
          }
          VCR.use_cassette('update_order') do
            @response = OpenPayU::Order.status_update(status_update)
            pp @retrieve_response
          end
        end
        it { @response.response.code.should eq '200' }
        it { @response.status['status_code'].should eq 'SUCCESS' }
        it { @response.status['status_desc'].should eq 'Request successful' }
      end

      context 'cancel order' do
        before(:all) do
          VCR.use_cassette('cancel_order') do
            @response = OpenPayU::Order.cancel(@response.order_id)
          end
        end
        it { @response.response.code.should eq '200' }
        it { @response.status['status_code'].should eq 'SUCCESS' }
        it { @response.status['status_desc'].should eq 'Request successful' }
      end

      describe ' Generate OrderNotifyResponse' do
        it do
          OpenPayU::Order.build_notify_response(3_243_243_324_342)
            .should include('SUCCESS')
        end
      end

    end
  end
end

describe 'Create hosted order' do

end
