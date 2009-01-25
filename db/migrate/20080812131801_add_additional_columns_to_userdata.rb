class AddAdditionalColumnsToUserdata < ActiveRecord::Migration
  def self.up
    add_column :userdatas, :password_updated_on, :datetime, :default => Time.now
    add_column :userdatas, :password_faults, :integer, :default => 0
  end

  def self.down
    remove_column :userdatas, :password_updated_on
    remove_column :userdatas, :password_faults
  end
end
