# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OpenPayU do
  it 'should sign a form' do
    form = {
      'TotalAmount' => '1000',
      'CompleteUrl' => 'http://localhost/complete'
    }
    OpenPayU.sign_form(form).should eq(
      'sender=145227;signature=0ed9664e79d56de68ea991f3ec7bd53f;algorithm=MD5'
      )
  end

  it 'should generate form' do
    order = TestObject::Order.valid_order
    form = OpenPayU.hosted_order_form(order).gsub(/>\s+</, '><')
    form.should match(/<form method='post' action='.*'>/)
    form.should match(/(<input type='hidden' name='.*' value='.*' \/>)+/)
    form.should match(/(<button type='submit' formtarget='_blank' \/>){1}/)
    form.should match(/<\/form>/)
  end

end
