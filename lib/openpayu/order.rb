module OpenPayU

  class Order


    def create(order)
      @order = Models::Order.new(order)
      if @order.valid?
        url = OpenPayU::Configuration.get_base_url + "order." + OpenPayU::Configuration.data_format
        data = OpenPayU::Document.create(@order)
        @response = Connection.post(url, @order)
      else
        # TODO: invalid order do something!
      end
    end

    #     public static function create($order)
    # {

    #     $result = self::verifyResponse(OpenPayU_Http::post($pathUrl, $data), 'OrderCreateResponse');

    #     return $result;
    # }

   

  end

end