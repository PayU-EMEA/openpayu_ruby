module OpenPayU

  class Order

    def self.retrieve(order_id)
      url = Configuration.get_base_url + "order/#{order_id}." + Configuration.data_format
      request = Documents::Request.new(url)
      Documents::Response.new
        Connection.get(url, request.body, request.headers), "OrderRetrieveResponse"
    end

    def self.create(order)
      @order = Models::Order.new(order)
      if @order.all_objects_valid?
        url = Configuration.get_base_url + "order." + Configuration.data_format
        request = Documents::Request.new(@order.prepare_data("OrderCreateRequest"))
        Documents::Response.new
          Connection.post(url, request.body, request.headers), "OrderCreateResponse"
      else
        raise WrongOrderParameters.new(@order)
      end
    end

    def self.status(status_update)
      raise NotImplementedException, "This feature is not yet implemented"
      @update = OpenPayU::Models::StatusUpdate.new status_update
      url = Configuration.get_base_url + "order/status." + Configuration.data_format
      request = Documents::Request.new(@update.prepare_data("OrderStatusUpdateRequest"))
      Documents::Response.new
        Connection.post(url, request.body, request.headers), "OrderStatusUpdateResponse"
    end

    def self.cancel(order_id)
      raise NotImplementedException, "This feature is not yet implemented"
      url = Configuration.get_base_url + "order/#{order_id}." + Configuration.data_format
      request = Documents::Request.new(url)
      Documents::Response.new
        Connection.delete(url, request.body, request.headers), "OrderCancelResponse"
    end

    def self.consume_notification(request)
      response = Documents::Response.new({response: request, request: nil}, "OrderNotifyRequest")
      unless response.nil?
        response
      else
        raise WrongNotifyRequest, "Invalid OrderNotifyRequest: #{request.inspect}"
      end
    end

    def self.build_notify_response(request_id)
      response = Models::NotifyResponse.new({
        res_id: request_id,
        status: { 'StatusCode' => 'SUCCESS'} 
      })
      response.prepare_data("OrderNotifyResponse")
    end

  end

end
