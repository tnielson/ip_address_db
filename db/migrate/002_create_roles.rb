class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :role_name, :string
      t.column :description, :string
      t.timestamps
    end
    rename_column :users, :username, :user_name
    add_column :users, :role_id, :integer, :null => false
  end

  def self.down
    drop_table :roles
    rename_column :users, :user_name, :username
    remove_column :users, :role_id
  end
end
