require File.dirname(__FILE__) + '/../test_helper'

#### Ü B E R S I C H T ####
#  1 - Ipnet create / save 
#  2 - Ipnet ohne Attribute erstellen
#  3 - Ipnet aus der DB abrufen können / nicht können
#  4 - Ipnet & nested children destroy
#  5 - Unique von Name überprüfen
#  6 - Liegt das zu erstellende Netz im Parent-Netz
#  7 - Existiert die IP bereits in einem Unique-Netz?
#  8 - Kollidiert das Netz mit anderen Unique-Netzen
#
#  
# Split / Join (bei Split auch auf /32 achten!)
# Methoden überprüfen, ob syntaktische Elemente integriert sind -> Test (Fehlererzeugung wichtig) 
#
#### Better Nested Set ####  
#  1 - Wird parent_id bei move_to richtig gesetzt?
#  2 - Werden lft und rgt bei move_to richtig gesetzt?
#  3 - move_to auf gültige Schritte überprüfen


class IpnetTest < ActiveSupport::TestCase
  
  def test_truth
    assert true
  end  
  
## Standard-Errors überschreiben -> eleganterer Weg??  
#ActiveRecord::Errors.default_error_messages[:taken] = "ist bereits vergeben"
#  
#  ##  1 ## Ist es möglich, ein Ipnetz zu erstellen und zu speichern?
#  def test_valid_new_ipnet_with_attributes
#    ipnet = Ipnet.new(:name     => "IP-Netz1",
#                      :ipaddr   => "10.0.0.1",
#                      :netmask  => "255.255.255.0")
#    assert ipnet.valid?
#    assert ipnet.save
#    ipnet.save
#    assert_nothing_raised {Ipnet.find(:first, :conditions => "name = 'IP-Netz1'")}   
#  end  
#  
#    
#  ##  2 ## Werden Fehler ausgegeben, falls ein Ipnetz ohne Attribute erstellt wird?
#  def test_invalid_new_ipnet_without_attributes
#    ipnet = Ipnet.new
#    assert !ipnet.valid?
#    assert ipnet.errors.invalid?(:name)
#    assert ipnet.errors.invalid?(:ipaddr)
#  end
#  
#  
#  ##  3 ## Daten aus der DB abrufen können / nicht können
#  def test_fetch_ipnet
#    fetch_success = Ipnet.find(ipnets(:root))
#    assert !fetch_success.nil?    
#    assert_raise(ActiveRecord::RecordNotFound) {fetch_failure = Ipnet.find(999999999)}
#  end
#  
#  
#  ##  4 ## Wird ein Ipnetz und deren chilrend auch wirklich gelöscht?
#  def test_ipnet_deleted
#    root1 = Ipnet.new(:name     => "root1",
#                      :ipaddr   => "0.0.0.0",
#                      :netmask  => "0.0.0.0")
#    
#    root1.save
#    
#    first = Ipnet.new(:name     => "first",
#                      :ipaddr   => "10.0.0.0",
#                      :netmask  => "255.0.0.0")
#    
#    first.save
#    
#    second = Ipnet.new(:name     => "second",
#                      :ipaddr   => "10.1.0.0",
#                      :netmask  => "255.255.0.0")
#                      
#    second.save
#
#    temp_id1 = first.id
#    temp_id2 = second.id
#    
#    first.move_to_child_of(root1)
#    second.move_to_child_of(first)
#    
#    @ipnet = Ipnet.find(:first, :conditions => "name = 'first'")
#    
#    Ipnet.destroy_all(["parent_id = @ipnet.id"])
#    @ipnet.destroy
#    
#    assert_raise(ActiveRecord::RecordNotFound) {Ipnet.find(temp_id1)}
#    assert_raise(ActiveRecord::RecordNotFound) {Ipnet.find(temp_id2)}
#  end
#  
#    
#  ##  5 ## Ist der Name bereits vergeben?
#  def test_unique_name
#    ipnet = Ipnet.new(:name     => ipnets(:A).name,
#                      :ipaddr   => "192.168.0.1",
#                      :netmask  => "255.255.255.252")
#                    
#    assert !ipnet.save
#    assert_equal ActiveRecord::Errors.default_error_messages[:taken], ipnet.errors.on(:name)
#  end
#
#  
#  ##  6 ## Liegt das zu erstellende Netz im Parent-Netz?
#  def test_ipnet_in_parent_net
#    net_object_parent = NetAddr::CIDR.create("#{ipnets(:root).ipaddr} #{ipnets(:root).netmask}")  
#    net_object_child  = NetAddr::CIDR.create("#{ipnets(:A).ipaddr} #{ipnets(:A).netmask}")
#    assert net_object_parent.contains?(net_object_child)
#    assert !net_object_child.contains?(net_object_parent)
#    
#    ipnet = Ipnet.new(:name       => "parent",
#                      :ipaddr     => "0.0.0.0",
#                      :netmask    => "0.0.0.0",
#                      :parent_id  => "1")
#                      
#    parent = Ipnet.find(ipnets(:root))                  
#                      
#    assert !ipnet.am_i_valid?(ipnet, parent)
#    #assert_equal "Die IP liegt nicht im Rahmen des Parent.", ipnet.errors.on(:ipaddr)
#  end
#
#
#  ##  7 ## Existiert die IP bereits in einem Unique-Netz?
#  def test_exists_ipnet_in_unique_ipnet
#    ipnet = Ipnet.new(:name      => "unique2",
#                      :ipaddr    => ipnets(:Bb).ipaddr,
#                      :netmask   => ipnets(:Bb).netmask,
#                      :parent_id => ipnets(:Bb).parent_id)
#                      
#    #parent = Ipnet.find(ipnets(:Bb).parent_id)
#    parent = ipnets(:Bb) 
#                      
#    assert !ipnet.am_i_valid?(ipnet, parent)
#    #assert_equal ipnet.errors.on(:ipaddr), "ist für das Netz bereits vergeben"
#  end
#  
#  
#  ##  8 ## Kollidiert das Netz mit anderen Unique-Netzen?
#  def test_ipnet_collision
#    
#  end
#  
#  
#  ##  9 ## Join Ipnets
#  def test_join_ipnets
#    
#  end
#
#
#  ## 10 ## Split Ipnet
#  def test_split_ipnet
#    #splitnet = Ipnet.find(:first, :conditions => [:ipaddr == "10.2.0.0"])
#    
#  end
#  
#################### Better Nested Set ###########################  
#  
#  ##  1 ## Wird parent_id bei move_to richtig gesetzt?
#  def test_set_parent_id
#
#    root1 = Ipnet.new(:name     => "root1",
#                      :ipaddr   => "0.0.0.0",
#                      :netmask  => "0.0.0.0")
#    root1.save
#    
#    ipnet = Ipnet.new(:name     => "Test",
#                      :ipaddr   => "192.168.0.1",
#                      :netmask  => "255.255.255.252")
#    ipnet.save
#    
#    ipnet.move_to_child_of(root1)
#    
#    assert ipnet.parent_id == root1.id   
#  end
#  
#  ##  2 ## Werden lft und rgt bei move_to richtig gesetzt?
#  def test_set_lft_and_rgt
##    ipnet = Ipnet.new(:name     => "Aa1",
##                      :ipaddr   => "10.1.1.0",
##                      :netmask  => "255.255.255.0")
##    ipnet.save
##    ipnet.move_to_child_of(Ipnet.find(ipnets(:Aa)))
##    
##    assert ipnets(:root).lft == 1 && ipnets(:root).rgt == 16
##    assert ipnets(:A).lft == 2 && ipnets(:A).rgt == 9
##    assert ipnets(:B).lft == 10 && ipnets(:B).rgt == 15
##    assert ipnets(:Aa).lft == 3 && ipnets(:Aa).rgt == 6
##    assert ipnets(:Ab).lft == 7 && ipnets(:Ab).rgt == 8
##    assert ipnets(:Ba).lft == 11 && ipnets(:Ba).rgt == 12
##    assert ipnets(:Bb).lft == 13 && ipnets(:Bb).rgt == 14
##    
##    assert ipnet.lft == 4 && ipnet.rgt == 5
#    
#  end
#    
#  ##  3 ## Testet move_to auf legale und illegale Bewegungen
#  def test_move_to_function
#    
#    root1 = Ipnet.new(:name     => "root1",
#                      :ipaddr   => "0.0.0.0",
#                      :netmask  => "0.0.0.0")
#    
#    root1.save
#    
#    first = Ipnet.new(:name     => "first",
#                      :ipaddr   => "10.0.0.0",
#                      :netmask  => "255.0.0.0")
#    
#    first.save
#    
#    second = Ipnet.new(:name     => "second",
#                      :ipaddr   => "10.0.0.0",
#                      :netmask  => "255.0.0.0")
#    second.save
#    
#    first.move_to_child_of(root1)
#    second.move_to_child_of(root1) 
#    first.reload ## needed because first is stale
#    
#    # now we should have the situation described in the ticket
#    assert_nothing_raised {first.move_to_child_of(second)}
#    assert_raise(ActiveRecord::ActiveRecordError) {second.move_to_child_of(first)} # try illegal move
#    first.move_to_child_of(root1) # move it back
#    second.reload ## needed because second is stale
#    assert_nothing_raised {first.move_to_child_of(second)} # try it the other way-- first is now on the other side of second
#  end 
#  
#
##    def test_set_lft_and_rgt
##    ipnet = Ipnet.new(:name     => "Aa1",
##                      :ipaddr   => "10.1.1.0",
##                      :netmask  => "255.255.255.0")
##    ipnet.save
##    ipnet.move_to_child_of(@Aa)
##    
##    assert @root.lft == 1 && @root.rgt == 16
##    assert @A.lft == 2 && @A.rgt == 9
##    assert @B.lft == 10 && @B.rgt == 15
##    assert @Aa.lft == 3 && @Aa.rgt == 6
##    assert @Ab.lft == 7 && @Ab.rgt == 8
##    assert @Ba.lft == 11 && @Ba.rgt == 12
##    assert @Bb.lft == 13 && @Bb.rgt == 14
##    
##    assert ipnet.lft == 4 && ipnet.rgt == 5
##    
##  end
  
end
