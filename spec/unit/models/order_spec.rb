# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe OpenPayU::Models::Order do
  context 'create valid order' do
    let(:order) { OpenPayU::Models::Order.new(TestObject::Order.valid_order) }

    specify do
      expect(order).to be_valid
      expect(order.all_objects_valid?).to eq(true)
      expect(order.merchant_pos_id).to eq(OpenPayU::Configuration.merchant_pos_id)
    end

    context 'should be valid without buyer phone number' do
      before { order.buyer.phone = nil }

      specify do
        expect(order).to be_valid
        expect(order.all_objects_valid?).to eq(true)
        expect(order.merchant_pos_id).to eq(OpenPayU::Configuration.merchant_pos_id)
      end
    end


    context 'should create product objects' do
      before { order.products = [{ name: 'Produkt 1' }] }

      specify do
        expect(order.products.size).to eq(1)
        expect(order.products).to include(an_instance_of(OpenPayU::Models::Product))
      end
    end

    context 'prepare correct Hash' do
      specify do
        hash = order.prepare_keys
        hash.delete('ReqId')
        hash.has_key?('merchantPosId')
        hash.has_key?('buyer')
        hash.has_key?('products')
      end
    end
  end

  context 'create invalid order' do
    let(:order) do
      OpenPayU::Models::Order.new(
        {
          customer_ip: '127.0.0.1',
          ext_order_id: 1,
          description: 'New order',
          currency_code: 'PLN',
          total_amount: 1000,
          products: [
            { name: 'test1' },
            { name: 'test2' }
          ]
        }
      )
    end

    specify do
      expect(order).not_to be_valid
      expect(order.all_objects_valid?).not_to be(true)
    end
  end

end
