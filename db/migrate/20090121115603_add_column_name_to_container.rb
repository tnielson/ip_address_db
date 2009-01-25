class AddColumnNameToContainer < ActiveRecord::Migration
  def self.up
    add_column :containers, :name, :string, :null => false
  end

  def self.down
    remove_column :containers, :name
  end
end
