require "rails_helper"
require "pry"

RSpec.describe "Customer Controller", type: :request do
  before :each do
    @sub1 = Subscription.create!(title: "Green Tea Lovers", price: 5.50, status: true, frequency: "monthly")
    @sub2 = Subscription.create!(title: "White Tea Lovers", price: 7.50, status: true, frequency: "monthly")
    @tea1 = Tea.create!(title: "Arizona Green Tea", description: "Plastic bottle tea", temp: 2, brew_time: 0)
    @tea2 = Tea.create!(title: "Black Tea", description: "The rare kind", temp: 2, brew_time: 15)
    @tea3 = Tea.create!(title: "Silver Tea", description: "The ultimate rarety!", temp: 20, brew_time: 10)
    @test_customer = Customer.create!(first_name: "Jolly", last_name: "Green", email: "JollyGreen@gmail.com", address: "123 JollyGreen Street")
    @test_customer2 = Customer.create!(first_name: "Big", last_name: "Red", email: "BigRed@gmail.com", address: "123 BigRed Street")
    @test_customer.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer.id, status: true)
    @test_customer2.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer2.id, status: false)
    @test_customer2.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea3.id, customer_id: @test_customer2.id, status: true)
  end

  describe "Index Action" do
    it 'Returns all customer data' do
      get "/api/v1/customers"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      all_customers = JSON.parse(response.body, symbolize_names: true)
      expect(all_customers[:data]).to be_a Array
      expect(all_customers[:data].count).to eq(2)

      all_customers_data = all_customers[:data]
      all_customers_data.map do |customer|
        expect(customer[:id]).to be_a String
        expect(customer[:type]).to be_a String
        expect(customer[:type]).to eq("customer")
        expect(customer[:attributes]).to be_a Hash
        expect(customer[:attributes][:first_name]).to be_a String
        expect(customer[:attributes][:last_name]).to be_a String
        expect(customer[:attributes][:email]).to be_a String
        expect(customer[:attributes][:address]).to be_a String
      end
    end
  end

  describe "Show Action" do
    it 'Returns a specific customers data by id' do
      get "/api/v1/customers/#{@test_customer.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      customer = JSON.parse(response.body, symbolize_names: true)
      expect(customer[:data]).to be_a Hash

      customer_data = customer[:data]
      expect(customer_data[:id]).to be_a String
      expect(customer_data[:type]).to be_a String
      expect(customer_data[:type]).to eq("customer")
      expect(customer_data[:attributes]).to be_a Hash

      customer_attributes = customer[:data][:attributes]
      expect(customer_attributes[:first_name]).to be_a String
      expect(customer_attributes[:first_name]).to eq("Jolly")
      expect(customer_attributes[:last_name]).to be_a String
      expect(customer_attributes[:last_name]).to eq("Green")
      expect(customer_attributes[:email]).to be_a String
      expect(customer_attributes[:email]).to eq("JollyGreen@gmail.com")
      expect(customer_attributes[:address]).to be_a String
      expect(customer_attributes[:address]).to eq("123 JollyGreen Street")
    end
  end

  describe "Sad Paths" do
    it 'Provides a valid error when customer id does not exist' do
      get "/api/v1/customers/40000"
      expect(response).not_to be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a Hash
      expect(error[:error]).to be_a Hash
      expect(error[:error][:status]).to be_a String
      expect(error[:error][:status]).to eq("404")
      expect(error[:error][:title]).to be_a String
      expect(error[:error][:title]).to eq("Error")
      expect(error[:error][:message]).to be_a String
      expect(error[:error][:message]).to eq("Couldn't find Customer with 'id'=40000")
      expect(error[:error][:detail]).to be_a String
      expect(error[:error][:detail]).to eq("No Record Found")
    end
  end
end