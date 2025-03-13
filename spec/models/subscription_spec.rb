require "rails_helper"
require "pry"

RSpec.describe Subscription, type: :model do
  before :each do
    @sub1 = Subscription.create!(title: "Green Tea Lovers", price: 5.50, status: true, frequency: "monthly")
    @sub2 = Subscription.create!(title: "White Tea Lovers", price: 7.50, status: true, frequency: "monthly")
    @tea1 = Tea.create!(title: "Arizona Green Tea", description: "Plastic bottle tea", temp: 2, brew_time: 0)
    @tea2 = Tea.create!(title: "Black Tea", description: "The rare kind", temp: 2, brew_time: 15)
    @tea3 = Tea.create!(title: "Silver Tea", description: "The ultimate rarety!", temp: 20, brew_time: 10)
    @test_customer = Customer.create!(first_name: "Jolly", last_name: "Green", email: "JollyGreen@gmail.com", address: "123 JollyGreen Street")
    @test_customer2 = Customer.create!(first_name: "Big", last_name: "Red", email: "BigRed@gmail.com", address: "123 BigRed Street")
    @test_customer.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer.id, status: true)
    @test_customer2.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer2.id, status: true)
    @test_customer2.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea3.id, customer_id: @test_customer2.id, status: true)
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:frequency) }
  end

  describe "associations" do
    it { should have_many :subscription_teas }
    it { should have_many(:teas).through(:subscription_teas) }
    it { should have_many(:customers).through(:subscription_teas) }
  end

  describe "instance methods" do
    it 'Deactivates all subscription teas when subscription is deactivated' do
      @sub2.subscription_teas.map do |sub_tea|
        expect(sub_tea[:status]).to eq(true)
      end

      @sub2.update!(status: false)

      @sub2.subscription_teas.map do |sub_tea|
        expect(sub_tea[:status]).to eq(false)
      end
    end
  end
end