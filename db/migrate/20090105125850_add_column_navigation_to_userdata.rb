class AddColumnNavigationToUserdata < ActiveRecord::Migration
  def self.up
    add_column :userdatas, :navigation, :boolean, :default => false
  end

  def self.down
    remove_column :userdatas, :navigation
  end
end
