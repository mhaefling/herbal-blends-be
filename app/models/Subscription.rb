class Subscription < ApplicationRecord
  validates :title, :price, :status, :frequency, presence: true
  validates :price, numericality: { only_float: true, greater_than: 0 }

  has_many :subscription_teas
  has_many :teas, through: :subscription_teas
  has_many :customers, through: :subscription_teas

  
end