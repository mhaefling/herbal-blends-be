class Tea < ApplicationRecord
  validates :title, :description, :temp, :brew_time, presence: true
  validates :title, uniqueness: true
  
  has_many :subscription_teas
  has_many :subscriptions, through: :subscription_teas
  has_many :customers, through: :subscription_teas
end