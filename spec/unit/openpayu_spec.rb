require "spec_helper"

describe OpenPayU do
  it "should sign a form" do
    form = {
      "TotalAmount" => "1000",
      "CompleteUrl" => "http://localhost/complete"
    }
    OpenPayU.sign_form(form, "981852826b1f62fb24e1771e878fb42d").should eq "sender=45654;signature=7d4073dbcc85e3859ed4341891168717;algorithm=MD5"
  end

  it "should generate form" do
    order = TestObject::Order.valid_order
    OpenPayU.hosted_order_form(order).gsub(/>\s+</,"><").should match(/<form method='post' action='.*'>(<input type='hidden' name='.*' value='.*' \/>)+(<button type='submit' formtarget='_blank' \/>){1}<\/form>/)
  end

end
