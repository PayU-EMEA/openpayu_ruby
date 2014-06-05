# -*- encoding : utf-8 -*-
module OpenPayU

  # Create Refund for an Order

  class Refund

    # Creates a RefundCreateRequest
    #
    # @param [Hash] data A Hash object containing full {Models::Refund} object
    # @return [Documents::Response] Response class object order
    #   with RefundCreateResponse
    def self.create(data)
      refund = Models::Refund.new(data)
      @response = Documents::Response.new(
        Connection.post("orders/#{refund.order_id}/refund",  refund.prepare_data)
      )
    end
  end
end
