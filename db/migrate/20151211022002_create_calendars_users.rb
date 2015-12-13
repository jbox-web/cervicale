class CreateCalendarsUsers < ActiveRecord::Migration
  def change
    create_table :calendars_users do |t|
      t.integer :calendar_id
      t.integer :user_id
      t.string  :permissions, default: 'R'

      t.timestamps null: false
    end

    add_index :calendars_users, [:calendar_id, :user_id], unique: true
  end
end
