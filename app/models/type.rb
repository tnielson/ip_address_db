class Type < ActiveRecord::Base
  has_and_belongs_to_many :keys, :uniq => true
  
  attr_accessible(:id, :name)
end
