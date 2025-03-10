class ChangeAllColumnsInSubscriptionsToNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :subscriptions, :title, false
    change_column_null :subscriptions, :price, false
    change_column_null :subscriptions, :status, false
    change_column_null :subscriptions, :frequency, false
  end
end
