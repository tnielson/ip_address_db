require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
#  def test_username_and_password_presence
#    user = User.new
#    assert !user.save
#    user.user_name = 'tu100'
#    assert !user.save
#    user.password = 'siedler'
#    assert user.save
#  end
  
#  def test_username_uniqueness
#    user_a = User.new
#    user_a.user_name = 'tu200'
#    user_a.password = 'siedler'
#    assert user_a.save
#    user_b = User.new
#    user_b.user_name = 'tu200'
#    user_b.password = 'siedler'
#    assert !user_b.save
#  end


end
