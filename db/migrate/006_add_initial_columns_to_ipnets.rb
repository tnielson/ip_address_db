class AddInitialColumnsToIpnets < ActiveRecord::Migration
  def self.up
      add_column :ipnets, :ipaddr, :string, :null => false
      add_column :ipnets, :netmask, :string, :null => false
      add_column :ipnets, :parent_id, :integer
      add_column :ipnets, :lft, :integer, :null => false
      add_column :ipnets, :rgt, :integer, :null => false
      add_column :ipnets, :lock_version, :integer, :default => 0
  end

  def self.down
      remove_column :ipnets, :ipaddr, :string, :null => false
      remove_column :ipnets, :netmask, :string, :null => false
      remove_column :ipnets, :parent_id, :integer
      remove_column :ipnets, :lft, :integer, :null => false
      remove_column :ipnets, :rgt, :integer, :null => false
      remove_column :ipnets, :lock_version, :integer, :default => 0
  end
end
