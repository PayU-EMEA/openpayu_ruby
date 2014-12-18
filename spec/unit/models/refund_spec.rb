# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe OpenPayU::Models::Refund do
  context 'create valid refund' do
    let(:refund) do
      OpenPayU::Models::Refund.new({
        order_id: 1,
        description: 'Refund',
        amount: 1000
      })
    end
    specify do
      expect(refund).to be_valid
    end
  end

  context 'create invalid refund' do
    let(:refund) do
      OpenPayU::Models::Refund.new({
        amount: 1000
      })
    end
    specify do
      expect(refund).not_to be_valid
    end
  end
end
