#Root, KNSH
r = Ipnet.new
r.attributes = {:id => 1, :name => "root", :ipaddr =>"0.0.0.0", :netmask => "0.0.0.0", :unq => "0", :description => "Root-Netz" }
r.save
r.root

i = Ipnet.new
i.attributes =  {:id => 2, :name => "Testnetz", :ipaddr =>"10.0.0.0", :netmask => "255.0.0.0", :unq => "0", :description => "Testnetz" }
i.save
i.move_to_child_of(1)