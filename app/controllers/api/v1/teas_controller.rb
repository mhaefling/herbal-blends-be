class Api::V1::TeasController < ApplicationController
  def index
    all_teas = Tea.all
    meta_data = { total_available_teas: Tea.all.count }
    render json: TeasSerializer.new(all_teas, { params: { include_customer_count: true, include_subscription_count: true }, meta: meta_data }), status: :ok
  end

  def show
    tea = Tea.find_by(id: params[:id])
    render json: TeasSerializer.new(tea, { params: { include_customer_count: true, include_subscription_count: true }}), status: :ok
  end
end