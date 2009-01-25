namespace :db do
  desc "Executes cronjobs such as 'remind users 3 days before deactivation'"
  task(:map_horstdb_to_ipnet => :environment) do

    if !Ipnet.find_by_name("root")
      root = Ipnet.new(:name => "root", :ipaddr => "0.0.0.0", :netmask => "0.0.0.0", :unq => 0, :description => "root", :lvl => 0)
      root.save  
    end
    root = Ipnet.find_by_name("root")

##--------------------------
puts "------------ SCHRITT 0: ERSTELLE KNSH ------------"
    ##Schritt 0: Erstelle das Root-Netz KNSH
    
    knsh = Ipnet.new(:name => "KNSH", :ipaddr => "10.0.0.0", :netmask => "255.0.0.0", :unq => 0, :description => "KNSH Netz", :lvl => 1)
    knsh.save
    knsh.insert_element(root.id)

##--------------------------
puts "------------ SCHRITT 1: ERSTELLE VPNs ------------"
    ##Schritt 1: Erstelle die VPNs
    ##Erklärung: Suche alle VPNs aus der Tabelle und erstelle Datensätze mit entsprechender IPrange
    ##Iprange beinhaltet FK VPN_ID und die IPranges, allerdings für jedes VPN 2 Stück

    ##Suche alle Ipranges
    ##für jeden Datensatz: Suche in Vpn nach Datensatz mit FK ID und lese "Bezeichnung" aus
    ##für jeden Datensatz: Erstelle ein Ipnet-Objekt mit IP und Subnetz und erstelle den Namen VPN_aa_bbbb_cc, wobei
    ##aa = Nummer, bbbb = Bezeichnung und cc = 01 oder 02 ist (da es 2 IPranges für jedes VPN gibt)  

    ##Umsetzung
    ipranges = Iprange.find(:all)
    for iprange in ipranges do
      puts "Iprange_id: #{iprange.id} Iprange_vpn_id: #{iprange.is_vpn_id}"
      vpn = Vpn.find(iprange.is_vpn_id)
        
      vpn_nr = vpn.id.to_s  ##Achtung! Nachtragen: Auf den Addr.raum achten VPNxx-01 und -02!
      if vpn_nr.length == 1 #Füllt VPN ID auf 2 Stellen auf
        vpn_nr = vpn_nr.insert(0, '0')
      end
      
      
      ##Problem: VPN 33 hat 6 Ranges oder so. Lösung => Find abändern und Nummern manuell hochzählen
      #name = Ipnet.find_by_name("VPN_#{vpn.id}_#{vpn.bezeichnung}_01") ? "VPN_#{vpn.id}_#{vpn.bezeichnung}_02" : "VPN_#{vpn.id}_#{vpn.bezeichnung}_01"
      #Lösung:
      #NOCH VERSCHACHTELN!!! SOLL NUR AUSGEFÜHRT WERDEN, WENN SCHON 1 EXISTIERT
      
      queryname = "%"+"VPN_#{vpn_nr}_#{vpn.bezeichnung}_"+"%"
      netze = Ipnet.find(:all, :order => 'name DESC', :conditions => ['name LIKE ?', queryname])
      puts "gefundene Netze: #{netze.size}"
      if netze.size > 0
        string = netze.first.name
        neuezahl = (string[string.length-2, string.length].to_i + 1).to_s
        neuezahl = neuezahl.insert(0, '0') if neuezahl.length == 1 #Füllt einstellige Zahlen auf 
        name = "VPN_#{vpn_nr}_#{vpn.bezeichnung}_#{neuezahl}"
      else
        name = "VPN_#{vpn_nr}_#{vpn.bezeichnung}_01"
      end  
      puts "Name ist: #{name}"
      vpn_ipnet = Ipnet.new(:name => name, :ipaddr => iprange.adresse, :netmask => iprange.netmask, :unq => 0, :description => vpn.bezeichnung, :lvl => 1)
      puts "NEW: #{vpn_ipnet.name}"
      vpn_ipnet.save
      vpn_ipnet.insert_element(knsh.id)
    end

##--------------------------
puts "------------ SCHRITT 2: ERSTELLE NETZE ------------"
    ##Schritt 2: Weise allen VPNs die richtigen ZGRs zu
    ##Erklärung: Suche alle Interfaces: 
    ##Iprange beinhaltet FK VPN_ID; 
    ##Ip beinhaltet FK Iprange_ID UND FK ZGR_INT_ID
    
    ## ALT #### Suche alle !GENUTZTEN! IPs, gehe jeden durch und merke iprange_id und zgr_int_id
    ##für jeden Datensatz: suche in Iprange nach Datensatz mit gemerkter ID und lese "VPN_ID" aus -> merken
    ##für jeden Datensatz: suche in Zgr_int nach Datensatz mit gemerkter ID und lese "ZGR_ID" aus -> merken -> ID = ZGR, muss nur aufgefüllt werden auf 5 Stellen
    ##für jeden Datensatz: suche in Zgr nach Datensatz mit gemerkter ID und lese "ROUTERNAME" aus -> kommt in "Bemerkung" 
    ##für jeden Datensatz: suche in Vpn nach Datensatz mit gemerkter ID und lese "Bezeichnung" aus
    ##erstelle 

## NEU ## Suche alle genutzten IPs (Ip entspricht WAN-Netz) und erstelle WAN-Unterbereich + LAN-Ober- und Unterbereich
    wan_netze = Ip.find(:all, :conditions => ["is_zgr_int_id != ?", 0])
    for wan_netz in wan_netze do
      puts "Neues WAN-NETZ: WAN-NETZ.id = #{wan_netz.id}"
      #Iprange
      iprange = Iprange.find(wan_netz.is_iprange_id)
      
      #Suche passendes VPN (Parent) über IP -> IPrange -> VPN
      vpn_horstdb = Vpn.find(iprange.is_vpn_id)
      vpn_ipnet_name = "%"+vpn_horstdb.bezeichnung+"%" #Für den LIKE-Query auf Tabelle Ipnet, anders geht es nicht
      vpn_ipnet = Ipnet.find(:first, :conditions => ['ipaddr = ? and netmask = ? and name LIKE ?', iprange.adresse, iprange.netmask, vpn_ipnet_name])
      #puts "Treffer VPN-Suche: #{vpn_ipnet.size}"
      puts "VPN-CLASS: #{vpn_ipnet.class}"
      puts "Dazugehöriges VPN: #{vpn_ipnet.name}"
      #Finde das dazugehörige ! IPNET ! - Objekt, um lft, rgt, lvl und parent_id festzulegen
      #vpn_ipnet = Ipnet.find(:all, :conditions => ['name LIKE ?', vpn_ipnet_name])
      #Problem wie oben. Lösung => Suche über IP!
      #vpn_ipnet = Ipnet.find(:all, :conditions => ['ipaddr = ? and netmask = ?', iprange.adresse, iprange.netmask])
      
 ##NAMEN##     
      #Suche zugeordnetes Interface (Namensgebung)
      int = ZgrInt.find(wan_netz.is_zgr_int_id)
      #Suche zugeordneten ZGR (für Namensgebung)
      zgr = Zgr.find(int.is_zgr_id)


      #ZGR
      zgr_str = ZgrInt.find(wan_netz.is_zgr_int_id).is_zgr_id.to_s #Liest ZGR-Nr aus
      laenge = zgr_str.length
      (5 - laenge).times do |t| #Füllt ggf. die ZGR-Nr auf 5 Stellen auf
        zgr_str = zgr_str.insert(0, '0')
      end
     
      #VPN
      vpn_str = vpn_horstdb.id.to_s  ##Achtung! Nachtragen: Auf den Addr.raum achten VPNxx-01 und -02!
      if vpn_str.length == 1 #Füllt VPN ID auf 2 Stellen auf
        vpn_str = vpn_str.insert(0, '0')
      end
    
      name_wan = "ZGR_#{zgr_str}_VPN#{vpn_str}_WAN" #erstellt Namen
      name_lan = "ZGR_#{zgr_str}_VPN#{vpn_str}_LAN"       
      
 ##NETZE##

      #ACHTUNG !! wan/lan_ipnet könnte doppelt erstellt werden, wenn ein zgr 2 interfaces besitzt!!
      #Lösung: Überprüfen, ob Datensatz bereits als Ipnet existiert, falls nicht => neu anlegen      

      #erstelle NetAddr-Objekt, um IPs hochzählen zu können
      cidr = NetAddr::CIDR.create(wan_netz.ip)
    
      puts "Suchen eines WAN-Ipnet-Netzes:"
      wan_ipnet = Ipnet.find_by_name(name_wan) 
      puts "   Ergebnis der Suche: #{wan_ipnet}" 
      
      if wan_ipnet.nil?  
        #erstelle WAN-Netz mit ip = wan_netz, subnetz = wan_netz
        wan_ipnet = Ipnet.new(:name => name_wan, :ipaddr => cidr.ip, :netmask => wan_netz.subnet, :unq => 0, :description => "", :lvl => 2)
        wan_ipnet.save
        puts "Speicherung des WAN-Netzes: IN VPN.ID STEHT #{vpn_ipnet.id}"
        wan_ipnet.insert_element(vpn_ipnet.id) 
      end
      
      lan_ipnet = Ipnet.find_by_name(name_lan)
      if lan_ipnet.nil?
        #erstelle LAN-Netz mit ip = wan_netz + 4, subnetz = wan_netz
        lan_ipnet = Ipnet.new(:name => name_lan, :ipaddr => cidr.next_ip(:Bitstep => 4), :netmask => wan_netz.subnet, :unq => 0, :description => "", :lvl => 2)
        lan_ipnet.save
        lan_ipnet.insert_element(vpn_ipnet.id)  
      end
      
      puts "Netze sollten erstellt sein, bzw. gefunden worden sein"
      puts "   WAN: #{wan_ipnet}  LAN: #{lan_ipnet}"
      
## WEITERES PROBLEM: Es kommt vor, das ein ZGR mehrere Interfaces des gleichen VPNs besitzt! Also Nummerierung oder Interface Bez. mit hinein!       
        #erstelle WAN-PoP mit ip = wan_netz + 1, subnetz = wan_netz
        #queryname = "%"+name_wan_zgr+"%"
        puts "Erstelle Wan-PoP fuer Zgr #{zgr_str}"
        queryname = "%"+"ZGR_#{zgr_str}_INT_"+"%"+"_POP"+"%"
        puts "  Suchname: #{queryname}"
        ergebnisse = Ipnet.find(:all, :order => 'name DESC', :conditions => ['name LIKE ?', queryname])
        puts "   Es gibt schon #{ergebnisse.size} Interfaces, die auf das VPN verzweigen"
        if ergebnisse.size > 0
          puts "ich bastel namen mit neuer zahl"
          string = ergebnisse.first.name
          neuezahl = (string[string.length-6, 2].to_i + 1).to_s
          neuezahl = neuezahl.insert(0, '0') if neuezahl.length == 1 #Füllt einstellige Zahlen auf 
          name_wan_pop = "ZGR_#{zgr_str}_INT_#{neuezahl}_POP"
        else
          name_wan_pop = "ZGR_#{zgr_str}_INT_01_POP"
        end  
        puts "   Name soll werden: #{name_wan_pop}"
        
        wan_pop = Ipnet.new(:name => name_wan_pop, :ipaddr => cidr.next_ip(:Bitstep => 1), :netmask => wan_netz.subnet, :unq => 0, :description => "", :lvl => 3)
        puts wan_pop.save
        wan_pop.insert_element(wan_ipnet.id)
        
        
        #erstelle WAN-ZGR mit ip = wan_netz + 2, subnetz = wan_netz
        puts "Erstelle Wan-ZGR fuer Zgr #{zgr_str}"
        queryname = "%"+"ZGR_#{zgr_str}_INT_"+"%"+"_WZGR"+"%"
        ergebnisse = Ipnet.find(:all, :order => 'name DESC', :conditions => ['name LIKE ?', queryname])
        puts "   Es gibt schon #{ergebnisse.size} Interfaces, die auf das VPN verzweigen"
        if ergebnisse.size > 0
          puts "ich bastel namen mit neuer zahl"
          string = ergebnisse.first.name
          neuezahl = (string[string.length-7, 2].to_i + 1).to_s
          neuezahl = neuezahl.insert(0, '0') if neuezahl.length == 1 #Füllt einstellige Zahlen auf 
          name_wan_zgr = "ZGR_#{zgr_str}_INT_#{neuezahl}_WZGR"
        else
          name_wan_zgr = "ZGR_#{zgr_str}_INT_01_WZGR"
        end         
        puts "   Name soll werden: #{name_wan_zgr}"
        
        wan_zgr = Ipnet.new(:name => name_wan_zgr, :ipaddr => cidr.next_ip(:Bitstep => 2), :netmask => wan_netz.subnet, :unq => 0, :description => "", :lvl => 3)
        wan_zgr.save
        wan_zgr.insert_element(wan_ipnet.id)          
        
        
        #erstelle LAN-ZGR mit ip = wan_netz + 5, subnetz = wan_netz
        puts "Erstelle Lan-ZGR fuer Zgr #{zgr_str}"
        queryname = "%"+"ZGR_#{zgr_str}_INT_"+"%"+"_LZGR"+"%"
        ergebnisse = Ipnet.find(:all, :order => 'name DESC', :conditions => ['name LIKE ?', queryname])
        puts "   Es gibt schon #{ergebnisse.size} Interface(s), das/die auf das VPN verzweig(t)/en"
        if ergebnisse.size > 0
          puts "ich bastel namen mit neuer zahl"
          string = ergebnisse.first.name
          neuezahl = (string[string.length-7, 2].to_i + 1).to_s
          neuezahl = neuezahl.insert(0, '0') if neuezahl.length == 1 #Füllt einstellige Zahlen auf 
          name_lan_zgr = "ZGR_#{zgr_str}_INT_#{neuezahl}_LZGR"
        else
          name_lan_zgr = "ZGR_#{zgr_str}_INT_01_LZGR"
        end 
        puts "   Name soll werden: #{name_lan_zgr}"
        
        lan_zgr = Ipnet.new(:name => name_lan_zgr, :ipaddr => cidr.next_ip(:Bitstep => 5), :netmask => wan_netz.subnet, :unq => 0, :description => "", :lvl => 3)
        lan_zgr.save
        lan_zgr.insert_element(lan_ipnet.id) 
        
        
        #erstelle LAN-ÜGR mit ip = wan_netz + 6, subnetz = wan_netz
        puts "Erstelle Lan-ÜGR fuer Zgr #{zgr_str}"
        queryname = "%"+"ZGR_#{zgr_str}_INT_"+"%"+"_UEGR"+"%"
        ergebnisse = Ipnet.find(:all, :order => 'name DESC', :conditions => ['name LIKE ?', queryname])
        puts "   Es gibt schon #{ergebnisse.size} Interfaces, die auf das VPN verzweigen"
        if ergebnisse.size > 0
          puts "ich bastel namen mit neuer zahl"
          string = ergebnisse.first.name
          neuezahl = (string[string.length-7, 2].to_i + 1).to_s
          neuezahl = neuezahl.insert(0, '0') if neuezahl.length == 1 #Füllt einstellige Zahlen auf 
          name_lan_uegr = "ZGR_#{zgr_str}_INT_#{neuezahl}_UEGR"
        else
          name_lan_uegr = "ZGR_#{zgr_str}_INT_01_UEGR"
        end         
        puts "   Name soll werden: #{name_lan_uegr}"
        
        lan_uegr = Ipnet.new(:name => name_lan_uegr, :ipaddr => cidr.next_ip(:Bitstep => 6), :netmask => wan_netz.subnet, :unq => 0, :description => "", :lvl => 3)
        lan_uegr.save
        lan_uegr.insert_element(lan_ipnet.id)        
      
    end # for wan_netz in wan_netze do
    
  end #task
end #namespace