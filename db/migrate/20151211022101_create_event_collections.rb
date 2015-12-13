class CreateEventCollections < ActiveRecord::Migration
  def change
    create_table :event_collections do |t|
      t.references :eventable, polymorphic: true
      t.references :user
      t.datetime   :start_time
      t.datetime   :end_time
      t.string     :frequency
      t.datetime   :repeat_until
      t.boolean    :all_day, default: false

      t.timestamps null: false
    end

    add_index :event_collections, :eventable_type
    add_index :event_collections, :eventable_id
    add_index :event_collections, :user_id
    add_index :event_collections, :start_time
    add_index :event_collections, :end_time
  end
end
