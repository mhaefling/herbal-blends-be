class ChangeAllColumnsInCustomersToNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :customers, :first_name, false
    change_column_null :customers, :last_name, false
    change_column_null :customers, :email, false
    change_column_null :customers, :address, false
  end
end
