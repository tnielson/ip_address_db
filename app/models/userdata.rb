class Userdata < ActiveRecord::Base
  belongs_to :user
  
  def self.deactivated?
    return self.deactivated == true
  end
  
  #validates_uniqueness_of(:password1_salt, :password2_salt, :password3_salt, :password1_hash, :password2_hash, :password3_hash)
  
end
