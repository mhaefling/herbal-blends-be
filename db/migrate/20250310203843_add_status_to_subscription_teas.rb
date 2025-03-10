class AddStatusToSubscriptionTeas < ActiveRecord::Migration[7.1]
  def change
    add_column :subscription_teas, :status, :boolean
  end
end
