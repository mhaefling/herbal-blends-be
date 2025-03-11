require "rails_helper"

RSpec.describe SubscriptionTea, type: :model do
  describe "validations" do
    it { should validate_presence_of(:subscription) }
    it { should validate_presence_of(:tea) }
    it { should validate_presence_of(:customer) }
  end

  describe "associations" do
    it { should belong_to :subscription }
    it { should belong_to :tea }
    it { should belong_to :customer }
  end
end