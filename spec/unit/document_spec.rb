
describe OpenPayU::Document do
  let(:document) { OpenPayU::Document.new }

  it { document.generate_signature_structure('OpenPayUData', 'SHA-1', 'MerchantPosId', 'SignatureKey').should eq 'sender=MerchantPosId;signature=52bb16149d1a5ccc8ac05f8e435c30d82efd5364;algorithm=SHA-1' }
end