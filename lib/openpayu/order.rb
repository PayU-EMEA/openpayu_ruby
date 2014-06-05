# -*- encoding : utf-8 -*-
module OpenPayU

  # A class responsible for dealing with Order

  class Order

    # Retrieves information about the order
    # - Sends to PayU OrderRetrieveRequest
    #
    # @param [String] order_id PayU OrderId sent back in OrderCreateResponse
    # @return [Documents::Response] Response class object order
    #   with OrderRetrieveResponse
    def self.retrieve(order_id)
      Documents::Response.new(
        Connection.get("orders/#{order_id}", nil)
      )
    end

    # Creates new Order
    # - Sends to PayU OrderCreateRequest
    #
    # @param [Hash] order A Hash object containing full {Models::Order} object
    # @return [Documents::Response] Response class object order
    #   with OrderCreateResponse
    # @raise [WrongOrderParameters] if provided Hash 'order' isn't a valid
    #   object (with all required fields)
    def self.create(order)
      @order = Models::Order.new(order)
      if @order.all_objects_valid?
        Documents::Response.new(
          Connection.post('orders', @order.prepare_data)
        )
      else
        raise WrongOrderParameters.new(@order)
      end
    end

    # Updates Order status
    # - Sends to PayU OrderStatusUpdateRequest
    #
    # @param [Hash] status_update A Hash object containing full
    #   {Models::StatusUpdate} object
    # @return [Documents::Response] Response class object order
    #   with OrderStatusUpdateResponse
    # @raise [NotImplementedException] This feature is not yet implemented
    def self.status_update(status_update)
      @update = OpenPayU::Models::StatusUpdate.new status_update
      Documents::Response.new(
        Connection.put("orders/#{@update.order_id}/status", @update.prepare_data)
      )
    end

    # Cancels Order
    # - Sends to PayU OrderCancelRequest
    #
    # @param [String] order_id PayU OrderId sent back in OrderCreateResponse
    # @return [Documents::Response] Response class object order
    #   with OrderCancelResponse
    def self.cancel(order_id)
      Documents::Response.new(
        Connection.delete("orders/#{order_id}", nil)
      )
    end

    # Transforms OrderNotifyRequest to [Documents::Response]
    #
    # @param [Rack::Request||ActionDispatch::Request] request object od request
    #   received from PayU
    # @return [Documents::Response] Response class object order
    #   with OrderNotifyRequest
    # @raise [WrongNotifyRequest] when generated response is empty
    def self.consume_notification(request)
      response = Documents::Response.new(
        { response: request, request: nil }
      )
      if !response.nil?
        response
      else
        raise(
          WrongNotifyRequest,
          "Invalid OrderNotifyRequest: #{request.inspect}"
        )
      end
    end

    # Creates OrderNotifyResponse to send to PayU
    #
    # @param [String] request_id value of ReqId(UUID) from OrderNotifyRequest
    # @return [String] Response in XML or JSON (depends on gem configuration)
    def self.build_notify_response(request_id)
      response = Models::NotifyResponse.new({
        res_id: request_id,
        status: { 'statusCode' => 'SUCCESS' }
      })
      response.prepare_data
    end

  end

end
