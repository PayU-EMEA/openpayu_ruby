# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OpenPayU do
  it 'should sign a form' do
    form = {
      'TotalAmount' => '1000',
      'CompleteUrl' => 'http://localhost/complete'
    }
    expect(OpenPayU.sign_form(form)).to(
      match('sender=114207')
      .and match('signature=e83176051ce82949552bb787c6c16385;algorithm=MD5')
    )
  end

  it 'should generate form' do
    order = TestObject::Order.valid_order
    form = OpenPayU.hosted_order_form(order).gsub(/>\s+</, '><')
    expect(form).to(
      match(/<form method='post' action='.*'>/)
      .and match(/(<input type='hidden' name='.*' value='.*' \/>)+/)
      .and match(/(<button type='submit' formtarget='_blank' \/>){1}/)
      .and match(/<\/form>/)
    )
  end

end
