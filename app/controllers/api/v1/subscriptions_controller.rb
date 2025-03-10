class Api::V1::SubscriptionsController < ApplicationController
  def index
    all_subscriptions = Subscription.all
    meta_data = { meta: { total_subscriptions: Subscription.all.count }}
    render json: SubscriptionsSerializer.new(all_subscriptions, meta_data), status: :ok
  end

end