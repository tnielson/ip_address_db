class CreateIpnets < ActiveRecord::Migration
  def self.up
    create_table :ipnets do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :ipnets
  end
end
