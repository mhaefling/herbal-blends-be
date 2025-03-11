class Api::V1::TeasController < ApplicationController
  def index
    all_teas = Tea.all
    meta_data = { total_available_teas: Tea.all.count }
    render json: TeaSerializer.new(all_teas, { params: { include_customer_count: true, include_subscription_count: true }, meta: meta_data }), status: :ok
  end

  def show
    tea = Tea.find_by(id: params[:id])
    render json: TeaSerializer.new(tea, { params: { include_customer_count: true, include_subscription_count: true }}), status: :ok
  end

  def create
    new_tea = Tea.create!(title: tea_params[:title], description: tea_params[:description], temp: tea_params[:temp], brew_time: tea_params[:brew_time])
    render json: TeaSerializer.new(new_tea, { params: { include_customer_count: true, include_subscription_count: true }}), status: :ok
  end

  private
  
  def tea_params
    params.permit(:title, :description, :temp, :brew_time)
  end
end