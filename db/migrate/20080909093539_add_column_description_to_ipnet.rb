class AddColumnDescriptionToIpnet < ActiveRecord::Migration
  def self.up
    add_column :ipnets, :description, :string
  end

  def self.down
    remove_column :ipnets, :description
  end
end

