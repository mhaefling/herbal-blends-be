require "rails_helper"
require "pry"

RSpec.describe "Teas Controller", type: :request do
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
    it 'Returns a list of all available teas, with customer counts and subscription counts' do
      get "/api/v1/teas"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      all_teas = JSON.parse(response.body, symbolize_names: true)

      expect(all_teas[:data]).to be_a Array
      expect(all_teas[:data].count).to eq(3)

      all_teas_data = all_teas[:data]
      all_teas_data.map do |tea|
        expect(tea[:id]).to be_a String
        expect(tea[:type]).to be_a String
        expect(tea[:type]).to eq("tea")
        expect(tea[:attributes]).to be_a Hash
        expect(tea[:attributes][:title]).to be_a String
        expect(tea[:attributes][:description]).to be_a String
        expect(tea[:attributes][:temp]).to be_a Integer
        expect(tea[:attributes][:brew_time]).to be_a Integer
        expect(tea[:attributes][:customer_count]).to be_a Integer
        expect(tea[:attributes][:subscription_count]).to be_a Integer
      end

      all_teas_meta = all_teas[:meta]
      expect(all_teas_meta).to be_a Hash
      expect(all_teas_meta[:total_available_teas]).to be_a Integer
    end
  end

  describe "Show Action" do
    it 'Returns the details of a single requested Tea by id' do
      get "/api/v1/teas/#{@tea2.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      tea = JSON.parse(response.body, symbolize_names: true)
      
      expect(tea[:data]).to be_a Hash
      
      tea_data = tea[:data]
      expect(tea_data[:id]).to be_a String
      expect(tea_data[:type]).to be_a String
      expect(tea_data[:type]).to eq('tea')
      expect(tea_data[:attributes]).to be_a Hash

      tea_data_attributes = tea[:data][:attributes]
      expect(tea_data_attributes[:title]).to be_a String
      expect(tea_data_attributes[:description]).to be_a String
      expect(tea_data_attributes[:temp]).to be_a Integer
      expect(tea_data_attributes[:brew_time]).to be_a Integer
      expect(tea_data_attributes[:customer_count]).to be_a Integer
      expect(tea_data_attributes[:subscription_count]).to be_a Integer
    end
  end

  describe "Create Action" do
    it "Can create new teas" do
      new_tea = {
        title: "Special Blend",
        description: "This tea contains the magic ingrediant!",
        temp: 10,
        brew_time: 20
      }
      post "/api/v1/teas/", params: new_tea, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)

      new_tea = JSON.parse(response.body, symbolize_names: true)
      expect(new_tea[:data]).to be_a Hash
      
      new_tea_data = new_tea[:data]
      expect(new_tea_data[:id]).to be_a String
      expect(new_tea_data[:type]).to be_a String
      expect(new_tea_data[:type]).to eq("tea")
      expect(new_tea_data[:attributes]).to be_a Hash

      new_tea_attributes = new_tea[:data][:attributes]
      expect(new_tea_attributes[:title]).to be_a String
      expect(new_tea_attributes[:title]).to eq("Special Blend")
      expect(new_tea_attributes[:description]).to be_a String
      expect(new_tea_attributes[:description]).to eq("This tea contains the magic ingrediant!")
      expect(new_tea_attributes[:temp]).to be_a Integer
      expect(new_tea_attributes[:temp]).to eq(10)
      expect(new_tea_attributes[:brew_time]).to be_a Integer
      expect(new_tea_attributes[:brew_time]).to eq(20)
    end
  end
end