class CreateTableSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.column :key, :string
      t.column :value, :integer
    end
  end

  def self.down
    drop_table :settings
  end
  
end
