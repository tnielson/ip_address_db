class CreateAttris < ActiveRecord::Migration
  def self.up
    create_table :attris do |t|
      t.column :container_id, :integer, :null => false
      t.column :key_id, :integer, :null => false
      t.column :value, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :attris
  end
end
