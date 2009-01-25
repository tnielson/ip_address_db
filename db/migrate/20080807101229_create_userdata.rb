class CreateUserdata < ActiveRecord::Migration
  def self.up
      create_table :userdatas do |t|
        t.column :user_id, :integer, :null => false
        t.column :last_login, :datetime
        t.column :deactivated, :boolean, :default => true
        t.column :deactivation_reason, :string, :default => "Account muss noch bestätigt werden"
        t.column :deactivation_date, :timestamp, :default => Time.now
        t.column :default_startpage, :integer, :deafult => 0
        t.column :password1_salt, :string
        t.column :password1_hash, :string
        t.column :password2_salt, :string
        t.column :password2_hash, :string
        t.column :password3_salt, :string
        t.column :password3_hash, :string
    end
  end

  def self.down
    drop_table :userdatas
  end
end
