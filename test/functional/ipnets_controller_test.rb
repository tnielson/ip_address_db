require File.dirname(__FILE__) + '/../test_helper'

## Bedingungen abbilden!

class IpnetsControllerTest < ActionController::TestCase
  
  fixtures :ipnets, :users
  
  def setup
    #login_as(users(:superuser))
    @controller  = IpnetsController.new
    #@user_controller = UsersController.new
    @request     = ActionController::TestRequest.new
    @response    = ActionController::TestResponse.new
    login_as_superuser
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:ipnets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_get_edit
    get :edit, :id => ipnets(:B) 
    assert_response :success
  end

  #def test_should_create_ipnet
  #  assert_difference('Ipnet.count') do
  #    post :create, :ipnet => { }
  #end
 # assert_redirected_to ipnet_path(assigns(:ipnet))
  #end

#  def test_should_update_ipnet
#    put :update, :id => ipnets(:one), :ipnet => { }
#    assert_redirected_to ipnet_path(assigns(:A))
#  end

#  def test_should_destroy_ipnet
#    assert_difference('Ipnet.count', -1) do
#      delete :destroy, :id => ipnets(:A)
#    end
#
#    assert_redirected_to ipnets_path
#  end

#  def test_create_action
#    #login_as(users(:superuser))
#    param = { :name => 'neu aus Test', :ipaddr => '172.0.0.0', :netmask => '255.0.0.0', :parent_id => ipnets(:root).id, :lft => 1, :rgt => 2 }
#    num_ipnets = Ipnet.count
#    post :create, { :ipnet => param }, {:uid => ipnets(:root), :time => Time.now.gmtime.to_a.join(";") }
#    #post :create, :ipnet => param
#    assert_response :redirect
#    assert_redirected_to :action => :index
#    assert_equal num_ipnets + 1, Ipnet.count
#    assert Ipnet.find_by_name(param[:name])
#  end
  
#  def test_edit_action
#    get :edit, { :id => ipnets(:A).id }, {:uid => ipnets(:root), :time => Time.now.gmtime.to_a.join(";") }
#    assert assigns(:ipnet)
#    assert_equal assigns(:ipnet).class Ipnet
#    assert_equal assigns(:ipnet), ipnets(:A)
#  end
  
#  def test_update_action
#    param = { :name => 'neu aus Test', :ipaddr => '10.0.0.0', :netmask => '255.0.0.0', :parent_id => '1', :lft => 1, :rgt => 2 }
#    post :update, { :id => ipnets(:A).id, :ipnet => param }, {:uid => ipnets(:root), :time => Time.now.gmtime.to_a.join(";") }
#    assert_response :redirect
#    assert_redirected_to :action => :index
#    ipnet = Ipnet.find(ipnets(:A).id)
#    param.each do |k,v|
#      assert_equal v, ipnet.send(k)
#    end
#  end
  
  
  
end
