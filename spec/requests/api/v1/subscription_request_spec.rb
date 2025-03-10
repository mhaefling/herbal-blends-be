require "rails_helper"
require "pry"

RSpec.describe "Subscription Controller", type: :request do
  before :each do
    @sub1 = Subscription.create!(title: "Green Tea Lovers", price: 5.50, status: true, frequency: "monthly")
    @sub2 = Subscription.create!(title: "White Tea Lovers", price: 7.50, status: true, frequency: "monthly")
    @tea1 = Tea.create!(title: "Arizona Green Tea", description: "Plastic bottle tea", temp: 2, brew_time: 0)
    @test_customer = Customer.create!(first_name: "Jolly", last_name: "Green", email: "JollyGreen@gmail.com", address: "123 JollyGreen Street")
    @test_customer.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer.id, status: true)
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
        expect(sub[:type]).to eq("subscriptions")
        expect(sub[:attributes]).to be_a Hash
        expect(sub[:attributes][:title]).to be_a String
        expect(sub[:attributes][:price]).to be_a Float
        expect(sub[:attributes][:status]).to be_in([true, false])
        expect(sub[:attributes][:frequency]).to be_a String
        expect(sub[:attributes][:total_active_customers]).to be_a Integer
      end
    end
  end
end