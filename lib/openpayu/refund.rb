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
      url = Configuration.get_base_url + "order/#{refund.order_id}/refund." +
        OpenPayU::Configuration.data_format
      request = Documents::Request.new(
        refund.prepare_data('RefundCreateRequest')
      )
      @response = Documents::Response.new(
        Connection.post(url, request.body, request.headers),
        'RefundCreateResponse'
      )
    end
  end
end
