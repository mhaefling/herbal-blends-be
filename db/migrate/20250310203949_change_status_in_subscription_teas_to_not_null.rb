class ChangeStatusInSubscriptionTeasToNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :subscription_teas, :status, false
  end
end
