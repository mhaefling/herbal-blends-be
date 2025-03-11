require "rails_helper"
require "pry"

RSpec.describe "Subscription Controller", type: :request do
  before :each do
    @sub1 = Subscription.create!(title: "Green Tea Lovers", price: 5.50, status: true, frequency: "monthly")
    @sub2 = Subscription.create!(title: "White Tea Lovers", price: 7.50, status: true, frequency: "monthly")
    @tea1 = Tea.create!(title: "Arizona Green Tea", description: "Plastic bottle tea", temp: 2, brew_time: 0)
    @test_customer = Customer.create!(first_name: "Jolly", last_name: "Green", email: "JollyGreen@gmail.com", address: "123 JollyGreen Street")
    @test_customer2 = Customer.create!(first_name: "Big", last_name: "Red", email: "BigRed@gmail.com", address: "123 BigRed Street")
    @test_customer.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer.id, status: true)
    @test_customer2.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer2.id, status: false)
  end

  describe "Index Action" do
    it 'Can return a list of all subscriptions' do
      get "/api/v1/subscriptions"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      all_subs = JSON.parse(response.body, symbolize_names: true)
      expect(all_subs[:data]).to be_a Array
      expect(all_subs[:data].count).to eq(2)
      expect(all_subs[:meta][:total_subscriptions]).to be_a Integer
      expect(all_subs[:meta][:total_subscriptions]).to eq(2)

      all_subs[:data].each do |sub|
        expect(sub[:id]).to be_a String
        expect(sub[:type]).to be_a String
        expect(sub[:type]).to eq("subscription")
        expect(sub[:attributes]).to be_a Hash
        expect(sub[:attributes][:title]).to be_a String
        expect(sub[:attributes][:price]).to be_a Float
        expect(sub[:attributes][:status]).to be_in([true, false])
        expect(sub[:attributes][:frequency]).to be_a String
        expect(sub[:attributes][:total_active_customers]).to be_a Integer
      end
    end
  end

  describe "Show Action" do
    it 'Can show the details of a specific subscription' do
      get "/api/v1/subscriptions/#{@sub2.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      sub_info = JSON.parse(response.body, symbolize_names: true)
      expect(sub_info[:data]).to be_a Hash

      sub_info_data = sub_info[:data]
      expect(sub_info_data[:id]).to be_a String
      expect(sub_info_data[:type]).to be_a String
      expect(sub_info_data[:type]).to eq("subscription")
      expect(sub_info_data[:attributes]).to be_a Hash

      sub_info_attributes = sub_info[:data][:attributes]
      expect(sub_info_attributes[:title]).to be_a String
      expect(sub_info_attributes[:price]).to be_a Float
      expect(sub_info_attributes[:status]).to be_in([true, false])
      expect(sub_info_attributes[:frequency]).to be_a String
      expect(sub_info_attributes[:total_active_customers]).to be_a Integer

      sub_info_teas = sub_info[:data][:attributes][:teas]
      expect(sub_info_teas).to be_a Array
      sub_info_teas.each do |tea|
        expect(tea[:title]).to be_a String
        expect(tea[:description]).to be_a String
        expect(tea[:temp]).to be_a Integer
        expect(tea[:brew_time]).to be_a Integer
      end
    end
  end

  describe "Update Action" do
    it 'Allows the status of a supbscription to be updated' do

      get "/api/v1/subscriptions/#{@sub1.id}"
      current_status = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      expect(current_status[:status]).to eq(true)


      deact_sub = {
        status: "false"
      }
      patch "/api/v1/subscriptions/#{@sub1.id}", params: deact_sub, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)

      updated_sub = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      expect(updated_sub[:status]).to eq(false)
    end
  end

  describe "Sad Paths" do
    it 'Provides a valid error when subscription id does not exist' do
      get "/api/v1/subscriptions/105"
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
      expect(error[:error][:message]).to eq("Couldn't find Subscription with 'id'=105")
      expect(error[:error][:detail]).to be_a String
      expect(error[:error][:detail]).to eq("No Record Found")
    end
  end
end