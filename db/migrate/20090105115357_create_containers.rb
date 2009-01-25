class CreateContainers < ActiveRecord::Migration
  def self.up
    create_table :containers do |t|
      t.column :type_id, :integer, :null => false
      t.column :ipnet_id, :integer
        
      t.column :parent_id, :integer
      t.column :lft, :integer, :null => false
      t.column :rgt, :integer, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :containers
  end
end
