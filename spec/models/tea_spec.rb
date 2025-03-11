require "rails_helper"

RSpec.describe Tea, type: :model do
  before :each do
    @sub1 = Subscription.create!(title: "Green Tea Lovers", price: 5.50, status: true, frequency: "monthly")
    @sub2 = Subscription.create!(title: "White Tea Lovers", price: 7.50, status: true, frequency: "monthly")
    @tea1 = Tea.create!(title: "Arizona Green Tea", description: "Plastic bottle tea", temp: 2, brew_time: 0)
    @tea2 = Tea.create!(title: "Black Tea", description: "The rare kind", temp: 2, brew_time: 15)
    @tea3 = Tea.create!(title: "Silver Tea", description: "The ultimate rarety!", temp: 20, brew_time: 10)
    @test_customer = Customer.create!(first_name: "Jolly", last_name: "Green", email: "JollyGreen@gmail.com", address: "123 JollyGreen Street")
    @test_customer2 = Customer.create!(first_name: "Big", last_name: "Red", email: "BigRed@gmail.com", address: "123 BigRed Street")
    @test_customer3 = Customer.create!(first_name: "John", last_name: "Doe", email: "JohnDoe@gmail.com", address: "123 Doe Lane")
    @test_customer.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer.id, status: true)
    @test_customer2.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer2.id, status: false)
    @test_customer2.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea3.id, customer_id: @test_customer2.id, status: true)
    @test_customer3.subscription_teas.create!(subscription_id: @sub2.id, tea_id: @tea1.id, customer_id: @test_customer3.id, status: true)
  end

  describe "validations" do
    subject { Tea.create!(title: "Green Tea", description: "Everyone loves green tea", temp: 5, brew_time: 10) }
    
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:temp) }
    it { should validate_presence_of(:brew_time) }
    it { should validate_uniqueness_of(:title) }
  end

  describe "associations" do
    it { should have_many :subscription_teas }
    it { should have_many(:subscriptions).through(:subscription_teas) }
    it { should have_many(:customers).through(:subscription_teas)}
  end

  describe "instance methods" do
    it "returns the number of customers a tea has" do
      expect(@tea1.customer_count).to eq(3)
    end

    it "returns the number of subscriptions with this type of tea" do
      expect(@tea1.subscription_count).to eq(1)
    end
  end

end