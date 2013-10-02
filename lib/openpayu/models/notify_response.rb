module OpenPayU
  module Models
    class NotifyResponse < Model
      attr_accessor :res_id, :status
      validates :res_id, :status, presence: true
    end
  end
end