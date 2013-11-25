# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class Refund < Model
      attr_accessor :order_id, :ext_refund_id, :type, :amount,
        :commission_amount, :proxy_commision_amount, :currency_code,
          :description, :bank_description, :source_account_number
      validates :description, :order_id, presence: true

      def prepare_data(request_type)
        if OpenPayU::Configuration.data_format == 'xml'
          generate_xml(request_type)
        else
          {
            'OpenPayU' => {
              request_type => {
                'OrderId' => @order_id,
                'Refund' => prepare_keys(instance_values)
              }
            }
          }.to_json
        end
      end

      def generate_xml(request_type)
        '<?xml version="1.0" encoding="UTF-8"?>
        <OpenPayU xmlns="http://www.openpayu.com/20/openpayu.xsd">' +
          prepare_keys({
                'OrderId' => @order_id,
                'Refund' => prepare_keys(instance_values)
              }).to_xml(
                builder: OpenPayU::XmlBuilder.new(request_type, indent: 2),
                root: request_type,
                skip_types: true,
                skip_instruct: true
              ) + '</OpenPayU>'
      end

    end
  end
end
