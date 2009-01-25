class AddColumnLvlToIpnets < ActiveRecord::Migration
  def self.up
    add_column :ipnets, :lvl, :integer, :default => 0
  end

  def self.down
    remove_column :ipnets, :lvl
  end
end
