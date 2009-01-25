class UserAddBehoerde < ActiveRecord::Migration
  def self.up
    add_column :users, :behoerde, :string
  end

  def self.down
    remove_column :users, :behoerde
  end
end
