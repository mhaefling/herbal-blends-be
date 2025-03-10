require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "validations" do
    subject { Customer.create!(first_name: "Jolly", last_name: "Green", email: "jollygreen@gmail.com", address: "1 Jolly Green Road") }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:address) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "associations" do
    it { should have_many :subscription_teas }
    it { should have_many(:subscriptions).through(:subscription_teas) }
    it { should have_many(:teas).through(:subscription_teas) }
  end
end