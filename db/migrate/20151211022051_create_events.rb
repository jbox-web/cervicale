class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string     :uuid
      t.references :eventable, polymorphic: true
      t.references :user
      t.string     :title
      t.text       :description
      t.string     :location
      t.string     :color
      t.string     :role, default: 'event'
      t.datetime   :start_time
      t.datetime   :end_time
      t.boolean    :all_day, default: false
      t.integer    :event_collection_id
      t.string     :visibility, default: 'PUBLIC'

      t.timestamps null: false
    end

    add_index :events, :uuid, unique: true
    add_index :events, :eventable_type
    add_index :events, :eventable_id
    add_index :events, :user_id
    add_index :events, :start_time
    add_index :events, :end_time
    add_index :events, :event_collection_id
  end
end
