require "openpayu/xml_builder"
require "openpayu/version"
require "openpayu/configuration"
require "openpayu/connection"
require "openpayu/exceptions"
require "openpayu/order"
require "openpayu/refund"
require "openpayu/token"
require "openpayu/document"
require "openpayu/documents/request"
require "openpayu/documents/response"
require "openpayu/models/model"
require "openpayu/models/address"
require "openpayu/models/buyer"
require "openpayu/models/buyer/delivery"
require "openpayu/models/buyer/invoice"
require "openpayu/models/card"
require "openpayu/models/fee"
require "openpayu/models/order"
require "openpayu/models/token"
require "openpayu/models/pay_method"
require "openpayu/models/product"
require "openpayu/models/shipping_method"
require "openpayu/models/refund"
require "openpayu/models/status_update"
require "openpayu/models/notify_response"

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
  
end
