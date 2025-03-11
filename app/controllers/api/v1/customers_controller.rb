class Api::V1::CustomersController < ApplicationController
  def index
    all_customers = Customer.all
    meta_data = { meta: { total_customers: Customer.all.count }}
    render json: CustomerSerializer.new(all_customers, meta_data), status: :ok
  end

  def show
    customer = Customer.find(params[:id])
    render json: CustomerSerializer.new(customer), status: :ok
  end
end