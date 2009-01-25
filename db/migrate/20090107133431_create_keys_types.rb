class CreateKeysTypes < ActiveRecord::Migration
  def self.up
    create_table(:keys_types, :id => false) do |t|
      t.column :key_id, :integer
      t.column :type_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :keys_types
  end
end
