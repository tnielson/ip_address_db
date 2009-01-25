class Ipnet < ActiveRecord::Base
  acts_as_nested_set
  require 'netaddr'
  
  attr_accessible(:id, :name, :ipaddr, :netmask, :description)
 
  def to_s
    return self.name
  end
  
  def self.search(search, suchoption, page)
     puts "+++++++++++++++++++++++++++++ S E A R C H +++++++++++++++++++++++++++++++"
     if search 
       case suchoption
         when "Name"
            puts "ich suche nach ZGR: #{search}"
            paginate  :per_page => 15, :page => page,
                      :conditions => ['name like ?',  "%#{search}%"],
                      :order => 'name'
          when "IP"
            puts "ich suche nach IP: #{search}"
            paginate  :per_page => 15, :page => page,
                      :conditions => ['ipaddr like ?',  "%#{search}%"],
                      :order => 'name'       
          when "Netzmaske"
            puts "ich suche nach Netzmaske: #{search}"
            paginate  :per_page => 15, :page => page,
                      :conditions => ['netmask like ?',  "%#{search}%"],
                      :order => 'name'        
          else
            puts "Fehler bei Krit"
            return flash[:error] = "Suchkriterien stimmen nicht"
        end#case  
     else
       puts "Keine Suchkrit angegeben"
       return flash[:error] = "Bitte geben Sie Suchkriterien an"
     end#if
  end#search
  
  validates_presence_of(:name, :message => "Bitte geben Sie einen Namen ein")
  validates_presence_of(:ipaddr, :message => "Bitte geben Sie eine IP an")
  validates_uniqueness_of(:name, :message => "ist bereits vergeben")
    
  def am_i_valid?(object, parent)
    a = ip_in_parent?(object, parent)
    b = exists_ip_in_unique_net?(object, parent)
    
    if a == true && b == true
      return true 
    else
      return false
    end

  end


  def check_collision(succ, ip_new_obj)
    succ_addr = succ.ipaddr + " " + succ.netmask
    succ_net_obj = NetAddr::CIDR.create(succ_addr)
    if ip_new_obj.contains?(succ_net_obj) && succ.unq
      errors.add(:ipaddr, :netmask, :unq, "IP-Netz überschneidet sich mit anderen Unique-Netzen")
    elsif ip_new_obj.contains?(succ_net_obj) && !succ.unq
          
    end
  end
  
  def has_children?
    return true if !Ipnet.find_all_by_parent_id(self.id).empty?
  end
  
  def insert_element(parent)
    puts "  -- -- -- INSERT ELEMENT -- -- --"
    puts parent
            ###-START-### AN DIE RICHTIGE STELLE PACKEN ###-START-###
        all_children =  Ipnet.find(:all, :conditions => [ "parent_id = ?", parent], :order => 'name')

        if all_children.length == 0    #Kein Kind
          puts "Kein Kind"
          self.move_to_child_of(parent)
          #puts "NULL K: Element angefügt"
        elsif all_children.length == 1   #Genau 1 Kind
          puts "1 Kind"
          temp = Ipnet.find(:first, :conditions => [ "parent_id = ?", parent])
          if self.name > temp.name
            self.move_to_right_of(temp.id)
            #puts"1K: Element wurde an den Anfang gepackt"
          else
            self.move_to_left_of(temp.id)
            #puts "1K: Element ans Ende gehängt"
          end
        else          #Mehrere Kinder
          puts "Mehrere Kinder"
          erstes_ele =    all_children[0]
          letztes_ele =   all_children[all_children.length-1]
          if self.name < erstes_ele.name
             self.move_to_left_of(erstes_ele.id)
             #puts "xK: Element wurde an den Anfang gepackt, eventuell redundant, bedenke erste Überprüfung"
          elsif self.name > letztes_ele.name
             self.move_to_right_of(letztes_ele.id)
             #puts "xK: Element wurde ans Ende gehängt"
          else
            ##Muss dazwischen passen (Insertsort?)
            ## Suche von links an so lange, bis du einen gefunden hast, der kleiner ist, -> optional? dann guck, ob der gleich ist
            #puts "xK: Namen gibt es doppelt -> Soll es das geben???, sollte dazwischen eingefügt werden"
            #suche erstes kleinere ele  
            i = 0
            such_ele = all_children[i]
            while such_ele.name < self.name
              i += 1
              such_ele = all_children[i]
            end
           ##Nun hat er das 1. größere Element gefunden
           self.move_to_left_of(all_children[i])    
          end
        end    
        ###-ENDE-### AN DIE RICHTIGE STELLE PACKEN ###-ENDE-### 
        puts "  -- -- -- -------------- -- -- --"
  end

#################################  
########  P R I V A T E  ########
#################################  

  def exists_ip_in_unique_net?(object, parent)
    puts "\\\\ 1. IP IN UNIQUE_NET ?? \\\\"
    temp = Ipnet.find(:first, :conditions => ["parent_id = ? and unq = ?", parent, true])
    if not temp.nil?
      puts "ipnet.rb: Validierung fehlgeschlagen (Unique IP für das Netz bereits vergeben)"
      errors.add(:ipaddr, "ist für das Netz bereits vergeben.") and puts "ipnet.rb: Validierung fehlgeschlagen"
    else
      return true
    end
  end
  
  def ip_in_parent?(object, parent)
    puts "\\\\ 2. IP IN PARENT ?? \\\\ -----> ACHTUNG IN OBJECT UND PARENT STEHT: o: #{object}  p: #{parent}"
    parent_object = Ipnet.find(parent)
    
    puts "Object:      [IP] #{object.ipaddr}   [NETMASK] #{object.netmask}"   
    puts "Parent:      [IP] #{parent_object.ipaddr}   [NETMASK] #{parent_object.netmask}" 
    
    net_object_parent = NetAddr::CIDR.create("#{parent_object.ipaddr} #{parent_object.netmask}") #Erzeugt NetAddr-Obj des Parent
    net_object_ipnet = NetAddr::CIDR.create("#{object.ipaddr} #{object.netmask}")

    if not net_object_parent.contains?(net_object_ipnet)
      errors.add(:ipaddr, "Die IP liegt nicht im Rahmen des Parent.")
      puts "ipnet.rb: Validierung fehlgeschlagen (IP nicht im Rahmen d. Parent)"
    else
      return net_object_parent.contains?(net_object_ipnet)
    end  
  end

  
end
