class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string  :name
      t.string  :slug
      t.text    :description
      t.integer :owner_id
      t.boolean :active
      t.string  :timezone
      t.string  :color

      t.timestamps null: false
    end

    add_index :calendars, [:owner_id, :name], unique: true
    add_index :calendars, [:owner_id, :slug], unique: true
  end
end
