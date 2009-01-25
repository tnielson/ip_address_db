class Key < ActiveRecord::Base
  has_and_belongs_to_many :types, :uniq => true
  belongs_to :attri
  
  attr_accessible(:id, :key_name, :key_description)
end
