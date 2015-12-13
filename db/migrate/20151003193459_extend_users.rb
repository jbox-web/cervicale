class ExtendUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name,  :string
    add_column :users, :language,   :string
    add_column :users, :time_zone,  :string
    add_column :users, :theme,      :string, default: 'default'
    add_column :users, :authentication_token, :string

    add_column :users, :admin,   :boolean, default: false
    add_column :users, :enabled, :boolean, default: true

    add_index :users, :authentication_token, unique: true
  end
end
