require "rails_helper"

RSpec.describe Tea, type: :model do
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
end