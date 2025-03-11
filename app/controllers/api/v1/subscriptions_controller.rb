class Api::V1::SubscriptionsController < ApplicationController
  def index
    all_subscriptions = Subscription.all
    meta_data = { meta: { total_subscriptions: Subscription.all.count }}
    render json: SubscriptionSerializer.new(all_subscriptions, meta_data), status: :ok
  end

  def show
    subscription = Subscription.includes(:teas, subscription_teas: :customer).find(params[:id])
    render json: SubscriptionSerializer.new(subscription, params: { include_teas: true, include_customers: true }), status: :ok
  end

  def update
    subscription = Subscription.find(params[:id])
    subscription.update(status: sub_params[:status])
    render json: SubscriptionSerializer.new(subscription, params: { include_teas: true, include_customers: true }), status: :ok
  end

  private

  def sub_params
    params.permit(:status)
  end

end