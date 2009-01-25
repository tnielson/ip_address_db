class Container < ActiveRecord::Base
  acts_as_nested_set
  has_many :attris
  belongs_to :type

  attr_accessible(:id)
end
