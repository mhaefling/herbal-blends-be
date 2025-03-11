class SubscriptionTea < ApplicationRecord
  validates :subscription, :tea, :customer, presence: true
  
  belongs_to :subscription
  belongs_to :tea
  belongs_to :customer
end