class Attri < ActiveRecord::Base
  belongs_to :container
  has_many :keys
  attr_accessible(:id)
end
