class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :lastname, :string
      t.column :firstname, :string
      t.column :password_salt, :string
      t.column :password_hash, :string
      t.column :email, :string
      t.column :created_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
