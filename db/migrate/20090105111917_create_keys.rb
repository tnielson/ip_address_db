class CreateKeys < ActiveRecord::Migration
  def self.up
    create_table :keys do |t|
      t.column :key_name, :string, :null => false
      t.column :key_description, :string, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :keys
  end
end
