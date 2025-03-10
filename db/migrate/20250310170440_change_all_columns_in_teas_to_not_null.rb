class ChangeAllColumnsInTeasToNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :teas, :title, false
    change_column_null :teas, :description, false
    change_column_null :teas, :temp, false
    change_column_null :teas, :brew_time, false
  end
end
