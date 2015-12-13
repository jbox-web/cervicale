class CreateEventAttachments < ActiveRecord::Migration
  def change
    create_table :event_attachments do |t|
      t.integer :event_id
      t.string  :url

      t.timestamps null: false
    end

    add_index :event_attachments, :event_id
  end
end
