module OpenPayU
  module Documents
    class Request < Document
      attr_accessor :header, :data

      def initialize(data)

        # if OpenPayU::Configuration.data_format.downcase == "xml"
        #   @data = { 'OpenPayU' => { request_type => data.prepare_hash }}.to_xml
        # else 
        #   @data = { 'OpenPayU' => { request_type => data.prepare_hash }}.to_json
        # end

        @data = data
        # @data = {'OpenPayU' => {"OrderCreateRequest" => [
        #   'CustomerIp' => "127.0.0.1",
        #         'MerchantPosId' => OpenPayU::Configuration.merchant_pos_id,
        #         'ContinueUrl' => "http://localhost/",
        #         'ValidityTime' => '48000',
        #         'Description' => '...',
        #         'CurrencyCode' => 'PLN',
        #         'TotalAmount' => '10000',
        #         'Buyer' => [
        #             'Email' => 'dd@ddd.pl',
        #             'Phone' => '123123123',
        #             'FirstName' => 'Jaroslaw',
        #             'LastName' => 'Testowy',
        #             'Language' => 'pl_PL',
        #            'NIN' => '123123123'
        #         ],
        #         'PayMethods' => ["PayMethod" => [ 'Type' => 'CARD_TOKEN',
        #     'Value' => 'TOKC_WBHLQMQARHIVE5NNGYHQLY13K61']],
        #         'Products' => [
        #             'Product' => [
        #                 'Name' => 'Mouse',
        #                 'UnitPrice' => '10000',
        #                 'Quantity' => '1'
        #             ]]
        #               ]}}.to_json
        set_headers
      end

      def set_headers
        @header = {
          'OpenPayu-Signature' => generate_signature_structure(@data, OpenPayU::Configuration.algorithm, OpenPayU::Configuration.merchant_pos_id, OpenPayU::Configuration.signature_key)
        }
      end

    end
  end
end