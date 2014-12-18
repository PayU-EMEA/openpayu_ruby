# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OpenPayU::Document do
  let(:document) { OpenPayU::Document.new }

  it 'generates valid signature' do
    expect(document.generate_signature_structure(
      'OpenPayUData',
      'SHA-1',
      'MerchantPosId',
      'SignatureKey'
    )).to( 
      include('sender=MerchantPosId')
      .and include('signature=52bb16149d1a5ccc8ac05f8e435c30d82efd5364;algorithm=SHA-1')
    )
  end
end
