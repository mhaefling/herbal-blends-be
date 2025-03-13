class Subscription < ApplicationRecord
  validates :title, :price, :frequency, presence: true
  validates :price, numericality: { only_float: true, greater_than: 0 }

  has_many :subscription_teas
  has_many :teas, through: :subscription_teas
  has_many :customers, through: :subscription_teas

  after_update :subscription_teas_status_update, if: -> { saved_change_to_status? && !status }
  
  private

  def subscription_teas_status_update
    subscription_teas.update_all(status: false)
  end
end