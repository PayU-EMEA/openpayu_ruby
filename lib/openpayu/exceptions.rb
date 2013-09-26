#encoding: utf-8

class WrongConfigurationError < StandardError; end
class HttpStatusException < StandardError; end
class EmptyResponseError < StandardError; end
class WrongSignatureException < StandardError; end
class WrongNotifyRequest < StandardError; end
class NotImplementedException < StandardError; end
class WrongOrderParameters < StandardError

  def initialize(order)
    @order = order
  end

  def message
    @order.all_errors.collect do |k,v|
      "Class #{k} missing attributes: #{v.messages.inspect}"
    end
  end
end