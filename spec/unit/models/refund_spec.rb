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
    it { refund.valid?.should be_true }
  end

  context 'create invalid refund' do
    let(:refund) do
      OpenPayU::Models::Refund.new({
        amount: 1000
      })
    end
    it { refund.valid?.should be_false }
  end
end
