class Customer < ApplicationRecord
  validates :first_name, :last_name, :email, :address, presence: true 
  validates :email, uniqueness: true

  has_many :subscription_teas
  has_many :subscriptions, through: :subscription_teas
  has_many :teas, through: :subscription_teas
end