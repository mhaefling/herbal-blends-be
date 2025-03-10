class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :title
      t.float :price
      t.boolean :status
      t.string :frequency

      t.timestamps
    end
  end
end
