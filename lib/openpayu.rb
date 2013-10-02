require_relative "openpayu/xml_builder"
require_relative "openpayu/version"
require_relative "openpayu/configuration"
require_relative "openpayu/connection"
require_relative "openpayu/exceptions"
require_relative "openpayu/order"
require_relative "openpayu/refund"
require_relative "openpayu/token"
require_relative "openpayu/document"
require_relative "openpayu/documents/request"
require_relative "openpayu/documents/response"
require_relative "openpayu/models/model"
require_relative "openpayu/models/address"
require_relative "openpayu/models/buyer"
require_relative "openpayu/models/buyer/delivery"
require_relative "openpayu/models/buyer/invoice"
require_relative "openpayu/models/card"
require_relative "openpayu/models/fee"
require_relative "openpayu/models/order"
require_relative "openpayu/models/token"
require_relative "openpayu/models/pay_method"
require_relative "openpayu/models/product"
require_relative "openpayu/models/shipping_method"
require_relative "openpayu/models/refund"
require_relative "openpayu/models/status_update"
require_relative "openpayu/models/notify_response"

module OpenPayU


  # Generate a signature for signing form sent directly to PayU
  #
  # @param [Hash] form_fields Hash with all form fields with values
  # @param [String] signature_key defaults to OpenPayU::Configuration.signature_key
  # @param [String] algorithm defaults to OpenPayU::Configuration.algorithm
  # @param [String] merchant_pos_id defaults to OpenPayU::Configuration.merchant_pos_id
  # @return [String] Signature that should be inserted to field with name "OpenPayu-Signature"
  def self.sign_form(form_fields, signature_key = Configuration.signature_key, algorithm = Configuration.algorithm, merchant_pos_id = Configuration.merchant_pos_id)
    sorted_values = form_fields.sort.collect{|array| array[1]}.join
    Document.new.generate_signature_structure(sorted_values, algorithm, merchant_pos_id, signature_key)
  end

  def self.hosted_order_form(order)
    @order = Models::Order.new(order)
    render_hash = @order.to_flatten_hash
    html_form = "<form method='post' action='#{Configuration.get_base_url}order'>\n"
    render_hash.each do |key,value|
      html_form << "<input type='hidden' name='#{key}' value='#{value}' />\n"
    end

    html_form << "<input type='hidden' name='OpenPayu-Signature' value='#{self.sign_form(render_hash)}' />
      <button type='submit' formtarget='_blank' />\n</form>"
  end
  
end
