Role.create(:id => 1, :role_name => "Administrator", :description => "Superuser des Systems")
Role.create(:id => 2, :role_name => "Gast", :description => "Berechtigungen f&uuml;r nicht eingeloggte User")
u = User.create(:id => 1, :user_name => "Superuser", :password => "Start123", :role_id => 1)
udata = Userdata.new :last_login => Time.now
u.userdata = udata
u.save
Permission.set_new_permissions