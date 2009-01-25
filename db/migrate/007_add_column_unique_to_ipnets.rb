class AddColumnUniqueToIpnets < ActiveRecord::Migration
  def self.up
    add_column :ipnets, :unq, :boolean, :deafult => false
  end

  def self.down
    remove_column :ipnets, :unique
  end
end
