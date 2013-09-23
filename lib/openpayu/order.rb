module OpenPayU

  class Order


    def self.retrieve(order_id)
      url = Configuration.get_base_url + "order/#{order_id}." + Configuration.data_format
      request = Documents::Request.new(url)
      @response = Documents::Response.new(Connection.get(url, request.data, request.header))
    end


    def self.create(order)
      @order = Models::Order.new(order)
      if @order.valid?
        url = Configuration.get_base_url + "order." + Configuration.data_format
        request = Documents::Request.new(@order.prepare_data("OrderCreateRequest"))
        @response = Documents::Response.new(
          Connection.post(url, request.data, request.header)
        )
      else
        # TODO: invalid order do something!
      end
    end

    def self.cancel(order_id)
      url = Configuration.get_base_url + "order/#{order_id}." + Configuration.data_format
      request = Documents::Request.new(url)
      @response = Documents::Response.new(Connection.delete(url, request.data, request.header))
    end


  end

end