# -*- encoding : utf-8 -*-
module OpenPayU
  module Models
    class StatusUpdate < Model
      attr_accessor :customer_id, :customer_email, :order_id,
        :order_creation_date, :order_status, :custom_status, :reason
       validates  :order_id, :order_creation_date, :order_status, presence: true
       validates :order_status,
        inclusion: {
          in: Order::STATUSES
        }
    end
  end
end
