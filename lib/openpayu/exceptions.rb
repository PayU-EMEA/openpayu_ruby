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
    @order.errors.collect do |error|
      "Class  missing attributes: #{error.messages.inspect}"
    end
  end
end