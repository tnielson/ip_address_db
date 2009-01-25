class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :role_id, :integer, :null => false
      t.column :controller_name, :string
      t.column :action_name, :string
      t.column :permission, :string, :default => 'deny'
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
