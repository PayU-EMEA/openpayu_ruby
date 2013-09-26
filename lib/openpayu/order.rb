module OpenPayU

  #A class responsible for dealing with Order

  class Order

    # Retrieves information about the order
    # - Sends to PayU OrderRetrieveRequest
    #
    # @param [String] order_id PayU OrderId sent back in OrderCreateResponse
    # @return [Documents::Response] Response class object order with OrderRetrieveResponse
    def self.retrieve(order_id)
      url = Configuration.get_base_url + "order/#{order_id}." + Configuration.data_format
      request = Documents::Request.new(url)
      Documents::Response.new(
        Connection.get(url, request.body, request.headers), 
        "OrderRetrieveResponse"
      )
    end

    # Creates new Order
    # - Sends to PayU OrderCreateRequest
    #
    # @param [Hash] order A Hash object containing full {Models::Order} object
    # @return [Documents::Response] Response class object order with OrderCreateResponse
    # @raise [WrongOrderParameters] if provided Hash 'order' isn't a valid object (with all required fields) 
    def self.create(order)
      @order = Models::Order.new(order)
      if @order.all_objects_valid?
        url = Configuration.get_base_url + "order." + Configuration.data_format
        request = Documents::Request.new(@order.prepare_data("OrderCreateRequest"))
        Documents::Response.new(
          Connection.post(url, request.body, request.headers), 
          "OrderCreateResponse"
        )
      else
        raise WrongOrderParameters.new(@order)
      end
    end

    # Updates Order status
    # - Sends to PayU OrderStatusUpdateRequest
    #
    # @param [Hash] status_update A Hash object containing full {Models::StatusUpdate} object
    # @return [Documents::Response] Response class object order with OrderStatusUpdateResponse
    # @raise [NotImplementedException] This feature is not yet implemented
    # @note Not implemented! This method is used to accept money from client if POS has turned off autoreveive option. 
    def self.status(status_update)
      raise NotImplementedException, "This feature is not yet implemented"
      @update = OpenPayU::Models::StatusUpdate.new status_update
      url = Configuration.get_base_url + "order/status." + Configuration.data_format
      request = Documents::Request.new(@update.prepare_data("OrderStatusUpdateRequest"))
      Documents::Response.new(
        Connection.post(url, request.body, request.headers), 
        "OrderStatusUpdateResponse"
      )
    end

    # Cancels Order
    # - Sends to PayU OrderCancelRequest
    #
    # @param [String] order_id PayU OrderId sent back in OrderCreateResponse
    # @return [Documents::Response] Response class object order with OrderCancelResponse
    # @note Not implemented! Cancel can be performed only on orders with certain status.
    def self.cancel(order_id)
      raise NotImplementedException, "This feature is not yet implemented"
      url = Configuration.get_base_url + "order/#{order_id}." + Configuration.data_format
      request = Documents::Request.new(url)
      Documents::Response.new(
        Connection.delete(url, request.body, request.headers), 
        "OrderCancelResponse"
      )
    end

    # Transforms OrderNotifyRequest to [Documents::Response]
    #
    # @param [Rack::Request||ActionDispatch::Request] request object od request received from PayU
    # @return [Documents::Response] Response class object order with OrderNotifyRequest
    # @raise [WrongNotifyRequest] when generated response is empty
    def self.consume_notification(request)
      response = Documents::Response.new({response: request, request: nil}, "OrderNotifyRequest")
      unless response.nil?
        response
      else
        raise WrongNotifyRequest, "Invalid OrderNotifyRequest: #{request.inspect}"
      end
    end

    # Creates OrderNotifyResponse to send to PayU
    #
    # @param [String] request_id value of ReqId(UUID) from OrderNotifyRequest 
    # @return [String] Response in XML or JSON (depends on gem configuration)
    def self.build_notify_response(request_id)
      response = Models::NotifyResponse.new({
        res_id: request_id,
        status: { 'StatusCode' => 'SUCCESS'} 
      })
      response.prepare_data("OrderNotifyResponse")
    end

  end

end
