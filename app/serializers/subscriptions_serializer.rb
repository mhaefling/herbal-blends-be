class SubscriptionsSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :status, :frequency

  attribute :total_active_customers do |subscription|
    subscription.subscription_teas.where(status: true).distinct.count(:customer_id)
  end
end
