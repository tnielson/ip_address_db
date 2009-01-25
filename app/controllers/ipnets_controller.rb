class IpnetsController < ApplicationController
  protect_from_forgery :only => [:calculate_join]

  ### GET /ipnets
  ### GET /ipnets.xml
  def index  
    if not params[:current_object]
      @net = Ipnet.find(:first, :conditions => "name = 'root'") 
    else
      @net = Ipnet.find(params[:current_object]) #Sonst aktuelles Netz
    end
    
    session[:current_object] = @net.id
    @root = Ipnet.find(:first, :conditions => "name = 'root'") #Wozu? wird vllt. im Partial verwendet?

    if params[:search] #Suche wurde angestoßen
      @ipnets = Ipnet.search(params[:search], params[:suchoption], params[:page])
      @layout = "suche"
    else # normale Navigation
      @ipnets = Ipnet.paginate  :per_page => 280, :page => params[:page],
                                :conditions => ["parent_id = ?", @net.id],
                                :order => 'name'
      @layout = "normal"
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ipnets }
    end
  end
  


## New umschreiben
### GET /ipnets/new
### GET /ipnets/new.xml
  def new
    logger.info(" #### BEGINN #### Hier wird ipnets_controller/new aufgerufen #### BEGINN ####")
    @ipnet = Ipnet.new

    ##Wenn nach freiem IP-Adr.raum gesucht wird
    if !params[:ipnet_space]
      puts "SUCHEN"
      #first_free_ip = search_ipnet_space(session[:current_ipnet], params[:ipnet_space])
      #puts "Ergebnis: #{first_free_ip.ip} #{first_free_ip.netmask}"
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ipnet }
    end
    logger.info(" #### ENDE #### Hier wird ipnets_controller/new beendet #### ENDE ####")
  end

### POST /ipnets
### POST /ipnets.xml
  def create
    logger.info(" #### BEGINN #### Hier wird ipnets_controller/create aufgerufen #### BEGINN ####")
       
    set_ip_and_netmask  #Setzt IP + Netzmaske richtig -> Methode nötig aufgrund verschiedener Notationsarten des Netzes in new-View (z.B. IP/24 oder IP 255.255.255.0)
    
    #Parameter auslesen           
    @ipnet = Ipnet.new(params[:ipnet])
    parent = session[:current_ipnet]
    @ipnet.lvl = (Ipnet.find(parent).lvl + 1)
    
    
    respond_to do |format|
          if @ipnet.am_i_valid?(@ipnet, parent) && @ipnet.save ## Überprüfe mittels eigener Validierungsmethoden & Standardvalidierung, ob IP-Netz valide ist
            insert_element(@ipnet, parent) ##Legt lft, rgt & parent_id fest -> update des Elements durch better_nested_set (move_to_child_of)       
            flash[:notice] = 'IP-Netz wurde erfolgreich erstellt.'
            format.html { redirect_to(:action => "index") } 
            format.xml  { render :xml => @ipnet, :status => :created, :location => @ipnet }
          else
              logger.info("   ### ipnets_controller:create -> if @ipnet.save ELSE ###   ")
              format.html { render :action => "new"}
              format.xml  { render :xml => @ipnet.errors, :status => :unprocessable_entity, :selected => parent, @selected => parent }
          end
           logger.info(" #### ENDE #### Hier wird ipnets_controller/create beendet #### ENDE ####")
    end
  end  
  
### GET /ipnets/1/edit
  def edit
    logger.info(" #### BEGINN #### Hier wird ipnets_controller/edit aufgerufen #### BEGINN ####")
 
    @ipnet = Ipnet.find(params[:id])
    
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @ipnet }
    end
    logger.info(" #### ENDE #### Hier wird ipnets_controller/edit beendet #### ENDE ####")
  end

### PUT /ipnets/1
### PUT /ipnets/1.xml
  def update
    logger.info(" #### BEGINN #### Hier wird ipnets_controller/update aufgerufen #### BEGINN ####")
    @ipnet = Ipnet.find(params[:id])
    
    #Werte verändern, damit neues Objekt durch Validator läuft!
    @clone = Ipnet.new(params[:ipnet])
 

    #Für Validierung
    set_ip_and_netmask
    parent = @ipnet.parent_id

    respond_to do |format|
      if @ipnet.am_i_valid?(@clone, parent) && @ipnet.update_attributes(params[:ipnet]) ##????? updte_attributes? MEthode gibt es noch gar nicht
        puts "UPDATE ERFOLGREICH!!!!!!!"
        flash[:notice] = 'IP-Netz wurde erfolgreich geändert'
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        puts "UPDATE MISSLUNGEN!"
        format.html { render :action => "edit"}
        format.xml  { render :xml => @ipnet.errors, :status => :unprocessable_entity }
      end
      logger.info(" #### ENDE #### Hier wird ipnets_controller/update beendet #### ENDE ####")
    end
  end

### DELETE /ipnets/1
### DELETE /ipnets/1.xml
  def destroy
    logger.info(" #### BEGINN #### Hier wird ipnets_controller/destroy aufgerufen #### BEGINN ####")
    @ipnet = Ipnet.find(params[:id])
    parent = @ipnet.parent_id #für die Navigation
    Ipnet.destroy_all(["parent_id = @ipnet.id"]) #löscht anscheinend doch alle children, warum nicht nur die direkten?
    @ipnet.destroy #Netz selbst löschen
    respond_to do |format|
      flash[:notice] = 'IP-Netz und die dazugehörigen Children wurden erfolgreich gelöscht (warum auch immer..)'
      format.html { redirect_to(:action => "index", :current_ipnet => parent) } 
      format.xml  { head :ok }
    end
    logger.info(" #### ENDE #### Hier wird ipnets_controller/destroy beendet #### ENDE ####")
  end
  

def split
  
  if request.get?
      puts " ++++  ++++ S P L I T - GET ++++ ++++   "
   
      @net = Ipnet.find(session[:current_ipnet]) #aktuelles Netz
      @children = Ipnet.find(:all, :conditions => ["parent_id = ?", @net.id]) #children
      
      respond_to do |format|
          format.html # split.html.erb
      end
    
    
  else ##POST
      puts " ++++  ++++ S P L I T - POST ++++ ++++   "
      ##Ipnetz finden
      ipnet = Ipnet.find(params[:net][:ipnet])
      if ipnet.netmask == "255.255.255.255" #Fehler
         puts " ++++  ++++ S P L I T - POST - 255.255.255.255 ++++ ++++   "
        respond_to do |format|            
         flash[:error] = "ein /32-er Netz kann nicht mehr gesplittet werden"
         format.html {redirect_to :action => 'index'}
        end

      else #Kein Fehler
          arr = Array.new # Sammler für Split-Netze
      
          if params[:split_method][:option] == "netmask"
              begin
                ##Rufe splitmethode mit netzmaske auf
                split_netmask = params[:ipnet_netmask]
                NetAddr.validate_ip_netmask(split_netmask)
              rescue NetAddr::ValidationError
                flash[:error] = 'Bitte geben Sie eine gültige Netzmaske an'
                redirect_to(:action => "index")
              else
                  ##SPLITMETHODE netmask s.o
                  
                 netz = NetAddr::CIDR.create("#{ipnet.ipaddr} #{ipnet.netmask}")
                 a = NetAddr::CIDR.create("#{ipnet.ipaddr} #{split_netmask}") #erste ip
                 b = NetAddr::CIDR.create("#{a.next_ip} #{split_netmask}") #zweite ip
                 
                 if netz.contains?(a)
                   ##packe a rein?
                   arr << a
                    while netz.contains?(b)
                       ##füge b hinzu
                       arr << b 
                       b = NetAddr::CIDR.create("#{b.next_ip} #{split_netmask}") ##weise b nächste ip zu  
                    end #while
                  
                  ## speicher neue netze und lösche ursprüngliches netz
                  save_split_nets(arr, ipnet.name, ipnet.parent_id, ipnet.lvl)
                  ipnet.destroy #Netz selbst löschen
                    respond_to do |format|
                      flash[:notice] = 'IP-Netz wurde erfolgreich gesplittet'
                      format.html { redirect_to(:action => "index") }
                    end #respond
                  else
                     ##Selbst Netz A ist schon nicht drin -> Fehler
                    flash[:error] = 'Netz kann nicht gesplittet werden'
                    redirect_to(:action => "index")
                  end #If contains
              end #Begin                      
          elsif params[:split_method][:option] == "middle"
                   net_addr = ipnet.ipaddr+" "+ipnet.netmask
                   net = NetAddr::CIDR.create(net_addr)
                   netmask_int = net.to_i(:netmask) 
                   netmask_int = (netmask_int >> 1) | 0b10000000000000000000000000000000
                   object1 = NetAddr::CIDR.create(ipnet.ipaddr, :Mask => netmask_int)
                   arr << NetAddr::CIDR.create(object1.next_ip, :Mask => netmask_int)
                   #Überprüfung auf zu große children
                   #Suche alle children
                   children = Ipnet.find(:all, :conditions => ["parent_id = ?", ipnet.id])
                   if  valid_children_size?(children, object1.size)
                   # Sichern des urspruenglichen Netzes 
                   ipnet.update_attributes(:ipaddr => object1.ip, :netmask => object1.netmask_ext)
                   # Sichern des neuen Split-Netzes (in arr ist nur ein objekt)
                   save_split_nets(arr, ipnet.name, ipnet.parent_id, ipnet.lvl) 
                    respond_to do |format|
                      flash[:notice] = 'IP-Netz wurde erfolgreich gesplittet'
                      format.html { redirect_to(:action => "index") }
                    end #respond
                  else
                    flash[:error] = 'Netz kann nicht gesplittet werden'
                    redirect_to(:action => "index")
            end #if
          end #If Methoden Abfrage
          
          
      end #If Netzmaske valide / invalide
  end ## GET / POST End    
end #split
         
  
  def calculate_join
    logger.info(" - - - - - - - - - - - - - - - CALC JOIN START - - - - - - - - - - - - - - - - - -")
    puts "HUHUHUHUHUHUU"
    puts "Params müssen anscheind existieren... oder? #{params.empty?}"
    
    
    params.each do |k,v|
     puts "key #{k}     value #{v}"
    end
    @checked = Array.new #Neues Array
    params.each do |k,v| #Durchlaufe jedes Key-Value-Pärchen von Params
      if (k.to_i > 0) and params[k]['checked'].to_i > 0 then #[Wenn sich das Params Pärchen um eine Checkbox handelt]Wenn checkbox aktiviert ist und
        if i = Ipnet.find(k) then #Wenn es den Datensatz gibt
          @checked << i #Hänge Datensatz an das Array an
        end
      end
    end
    
    if @checked.empty?
       respond_to do |format|
          flash[:error] = 'Bitte wählen Sie Start- und Anfangsnetz für das Zusammenfassen'
          format.html { redirect_to(:action => "index") }
       end #respond
    else

    @checked = @checked.sort_by{ |element| element['ipaddr'] } #Sortiere Array nach IP-Adresse
    #In @checked stehen quasi first und last, allerdings IST DIE SORTIERUNG NICHT RICHTIG (wenn z.b. 10.40.0.0 und 10.255.0.0 sortiert werden würden, steht erst 255 dann 40!!
    
    @first = Ipnet.find(@checked[0]['id']) #Kleinstes !Objekt! des Arrays
    @last = Ipnet.find(@checked[@checked.length - 1]['id']) #Größtes !Objekt! des Arrays
       
    ## Alle zu joinenden IP-Netze suchen (zwischen größter und kleinster zu joinender IP)
    @ipnets = return_array_of_children_between_ipnets(@first,@last)
    ## die zu joinenden IP-Netze nach IP sortieren
    @ipnets = sort_ipnets(@ipnets) ##Kann in einer Zeile -> aber Verständlichkeit geht verloren

    ## IP + Subnetz kalkulieren (über calculate_subnet) und NetAddr-Objekt erzeugen
    @ip_new_object = NetAddr::CIDR.create(@first.ipaddr, :Mask => calculate_subnet(@first,@last)) 
     
    @ip_new = Ipnet.new
    @ip_new.name = @first.name
    @ip_new.ipaddr = @ip_new_object.ip
    @ip_new.netmask = @ip_new_object.netmask_ext
    
    ## Check auf Kollision (siehe im respond in if ...)
    ## Dazu "eigentlich" nur überprüfen, ob neuer Adressraum mit Nachfolger von last kollidiert
    
    ##Nachfolger suchen
    @nachfolger = search_successor_of_ipnet(@last)
    
   respond_to do |format|     
     if@nachfolger
      if @ip_new.check_collision(@nachfolger, @ip_new_object)
       if first.unq ##Kollision und Unique -> Fehler
         "     CALCULATE ÜBERSCHNEIDUNG & UNQ -> FEHLER"
         flash[:notice] = 'IP-Netz überschneidet sich mit anderen Unique-Netzen.'
         format.html { redirect_to(:action => "index")} 
         format.xml  { head :ok }
       else  ##Kollision, User muss entscheiden, ob Join durchgeführt werden soll#
         puts "     CALCULATE ÜBERSCHNEIDUNG"
         flash[:notice] = 'IP-Netz überschneidet sich mit anderen Netzen. Wollen Sie den Join wirklich durchführen?'
         format.html { render :action => "join_ipnet" } 
         format.xml  { render :xml => @ipnets, :status => :decision_join, :location => @ipnets }
       end  
     else #Keine Kollision
       puts "     CALCULATE PALETTI"
       flash[:notice] = 'IP-Netz kann problemlos gejoint werden.'
       format.html { render :action => "join_ipnet" } 
       format.xml  { render :xml => @ipnets, :status => :ready_to_join, :location => @ipnets }
     end
    else #Keine Kollision
       "     CALCULATE PALETTI"
       flash[:notice] = 'IP-Netz kann problemlos gejoint werden.'
       format.html { render :action => "join_ipnet" } 
       format.xml  { render :xml => @ipnets, :status => :ready_to_join, :location => @ipnets }
     end
     
     

   end 
   logger.info(" - - - - - - - - - - - - - - - CALC JOIN ENDE - - - - - - - - - - - - - - - - - -") 
   end #checked.nil If-Anweisung
  end
  
  def join_ipnet
    logger.info(" - - - - - - - - - - - - - - - JOIN IPNET START - - - - - - - - - - - - - - - - - -")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ipnets }
    end
    logger.info(" - - - - - - - - - - - - - - - JOIN IPNET ENDE - - - - - - - - - - - - - - - - - -")
  end

### POST /ipnets/packzusammen
### POST /ipnets/packzusammen.xml  
  def packzusammen
    logger.info(" - - - - - - - - - - - - - - - packzusammen START - - - - - - - - - - - - - - - - - -")
       logger.info(" #### BEGINN #### Hier wird ipnets_controller/perform join aufgerufen #### BEGINN ####")
    puts "       +++    PERFORM JOIN     +++"
    #ipnets         = params[:joinable_ipnets]
    first          = Ipnet.find(params[:first])
    last           = Ipnet.find(params[:last])
    parent = Ipnet.find(first.parent_id)
    #ipnets = Ipnet.find(:all, :conditions => ["ipaddr >= ? and ipaddr <= ? and parent_id = ?", first.ipaddr, last.ipaddr, parent.id])   
    
    #children_arr = Array.new
    children_arr = return_array_of_children_between_ipnets(first,last)
    ##CHILDREN SUCHEN
    #arr = Array.new
    #erster = NetAddr::CIDR.create("#{first.ipaddr} #{first.netmask}")
    #letzter = NetAddr::CIDR.create("#{last.ipaddr} #{last.netmask}")
    # while erster.ip != letzter.ip
    #    arr << erster if Ipnet.find(:first, :conditions => ["ipaddr = ? and netmask = ? and parent_id = ?", erster.ip, erster.netmask_ext, parent]) 
    #    erster = NetAddr::CIDR.create("#{erster.next_ip} #{erster.netmask_ext}")
    # end
    # arr << letzter 
      
     #children_arr = Array.new
     #arr.each do |a| 
     # children_arr << Ipnet.find(:first, :conditions => ["ipaddr = ? and netmask = ? and parent_id = ?", a.ip, a.netmask_ext, parent])  
     #end
    puts "children_arr"
    puts children_arr


### WIE SIEHT ES AUS, FALLS MAN 2 JOINEN WILL, WO ES GAR NICHT MÖGLICH IST???

    
    ## neues netz erstellen mit den daten von first
    puts "neues netz erstellen und an parent anhängen"
    t1 = Ipnet.new
    t1.name = "joined "+first.name #andere name wegen validate
    t1.ipaddr = params[:ip_new]
    t1.netmask = params[:netmask_new]
    t1.lvl = first.lvl
    t1.save!
    insert_element(t1, parent)

    ##children anhängen
    #puts "children anhängen"
    #  children_arr.each do |child|
    #    puts "verschiebe "+child.name+" zu "+t1.name
    #    insert_element(child, t1.id)
    #    #child.move_to_child_of(t1.id) #hat funktioniert, warum nun nicht mehr?
    #  end  
     puts "children des neuen netzes: "
     puts Ipnet.find(:all, :conditions => ["parent_id = ?", t1.id])

    ##netze löschen
    puts "netze löschen"
    logger.info("           - - - - - - - - - - - - - - - netze löschen start - - - - - - - - - - - - - - - - - -")
    children_arr.each do |net|
      del = Ipnet.find(net.id)
      puts "lösche "+net.name
      del.destroy
    end
    ("           - - - - - - - - - - - - - - - netze löschen ende - - - - - - - - - - - - - - - - - -")
    
    respond_to do |format|
      format.html { redirect_to(:action => "index", :selected => Ipnet.find(:first).id) } 
      format.xml  { render :xml => @ipnets }
    end


#    ##children durchlaufen
#    #children = Array.new
#    #ipnets.each do |k|
#    #  if i = Ipnet.find_all_by_parent_id(k.id)
#    #    children << i
#    #  end
#    #end
    
   
   # respond_to do |format|
   #   flash[:notice] = 'IP-Netze wurden gejoint'
   #   format.html { redirect_to(:action => "index", :selected => Ipnet.find(:first)) } 
   #   format.xml  { head :ok }
   # end
    logger.info(" - - - - - - - - - - - - - - - packzusammen ENDE - - - - - - - - - - - - - - - - - -")
  end

   

 
  

   
##################################################  
################# P R I V A T E  #################
##################################################  

  private

  def calculate_subnet(first,last)
    address_a = first.ipaddr + ' ' + first.netmask
    address_b = last.ipaddr + ' ' + last.netmask
    a = NetAddr::CIDR.create(address_a) #first ist immer die kleinste IP des Intervalls
    b = NetAddr::CIDR.create(address_b) #last ist immer die größte IP des Intervalls

    c = b.to_i(:ip) - a.to_i(:ip) # Differenz zwischen den IPs
     #   puts "Differenz zwischen den IPs: #{c}"
    size = c + b.size
     #   puts "Size = c + b.size : #{size}"
    pos = 0
    first_one = 0
    last_one = 0
    
    1.upto 32 do # Loop für 32 Stellen einer IP (binär)
      pos += 1
      temp = size & 1 # AND-Verknüpfung size mit 1
      #puts "temp nach Verknüpfung mit 1: Pos[#{pos}]#{temp}"
      if temp > 0 then #Wenn in temp eine 1 steht
        if first_one < 1 then #Wenn die erste 1 noch nicht gesetzt ist, 
          first_one = pos #Setze die erste 1 
          last_one = pos #und natürlich die letzte
        else
          last_one = pos #Sonst setze nur die letzte 1
        end
      end
      size = size >> 1 # Rechts-Shift von size um 1 Stelle (nächst größere size) ??
    end
    
    if last_one - first_one > 0 then #Wenn die first und last_one ungleich sind, ist die size kein Ergebnis aus 2^n, also
      last_one += 1 # Vergrößere die range um 1 bit
    end
    
    s = 1
    puts "size: #{size}"
    size = s << last_one - 1 #size hat nun die benötigte Größe des Netzes
    puts "size: #{size}"
    netmask = size - 1 ^ 0b11111111111111111111111111111111 #XOR, wandelt die binäre Zahl in Dec um
    puts " 1 XOR die binäre Zahl: #{1 ^ 0b11111111111111111111111111111111}"
    puts " die binäre Zahl:       #{0b11111111111111111111111111111111}"
    puts " netmask nach XOR:       #{netmask}"
    return netmask
  end

  
  
  
  
  def insert_element(object, parent)
    puts "  -- -- -- INSERT ELEMENT -- -- --"
    puts object
    puts parent
            ###-START-### AN DIE RICHTIGE STELLE PACKEN ###-START-###
        all_children =  Ipnet.find(:all, :conditions => [ "parent_id = ?", parent], :order => 'name')

        if all_children.length == 0    #Kein Kind
          puts "Kein Kind"
          object.move_to_child_of(parent)
          #puts "NULL K: Element angefügt"
        elsif all_children.length == 1   #Genau 1 Kind
          puts "1 Kind"
          temp = Ipnet.find(:first, :conditions => [ "parent_id = ?", parent])
          if object.name > temp.name
            object.move_to_right_of(temp.id)
            #puts"1K: Element wurde an den Anfang gepackt"
          else
            object.move_to_left_of(temp.id)
            #puts "1K: Element ans Ende gehängt"
          end
        else          #Mehrere Kinder
          puts "Mehrere Kinder"
          erstes_ele =    all_children[0]
          letztes_ele =   all_children[all_children.length-1]
          if object.name < erstes_ele.name
             object.move_to_left_of(erstes_ele.id)
             #puts "xK: Element wurde an den Anfang gepackt, eventuell redundant, bedenke erste Überprüfung"
          elsif object.name > letztes_ele.name
             object.move_to_right_of(letztes_ele.id)
             #puts "xK: Element wurde ans Ende gehängt"
          else
            ##Muss dazwischen passen (Insertsort?)
            ## Suche von links an so lange, bis du einen gefunden hast, der kleiner ist, -> optional? dann guck, ob der gleich ist
            #puts "xK: Namen gibt es doppelt -> Soll es das geben???, sollte dazwischen eingefügt werden"
            #suche erstes kleinere ele  
            i = 0
            such_ele = all_children[i]
            while such_ele.name < object.name
              i += 1
              such_ele = all_children[i]
            end
           ##Nun hat er das 1. größere Element gefunden
           object.move_to_left_of(all_children[i])    
          end
        end    
        ###-ENDE-### AN DIE RICHTIGE STELLE PACKEN ###-ENDE-### 
        puts "  -- -- -- -------------- -- -- --"
  end
 
  
  def set_ip_and_netmask
        ##Wenn IP und Netzmaske in einem Feld##
     if params[:ipnet][:netmask] == ''
       net_object = NetAddr::CIDR.create(params[:ipnet][:ipaddr])
       params[:ipnet][:netmask] = net_object.netmask_ext()
       params[:ipnet][:ipaddr] = net_object.ip
       puts 'Netzmaske aus Prefix-Notation erstellt, netmask-Feld muss dazu leer sein!'+net_object.netmask
    
     else #IP und Netzmaske getrennt, Validierung wie realisieren?
        if NetAddr.validate_ip_addr(params[:ipnet][:ipaddr]) && NetAddr.validate_ip_netmask(params[:ipnet][:netmask])
          puts "Validierung [NetAddr] der IP erfolgreich Netzmaske + IP getrennt"
        else
         raise "Validierung [NetAddr] der IP fehlgeschlagen Netzmaske + IP getrennt"
        end
        #puts 'Netzmaske angegeben, noch realisieren mit beiden Feldern -> Error'+params[:ipnet][:netmask]
     end  
 end
 
 def save_split_nets(anArray, netzname, parent, level)
   count = 0 
   anArray.each do |a|
     count += 1
     name = "#{netzname}_split_#{count}"
     ipnet = Ipnet.new(:name => name, :ipaddr => a.ip, :netmask => a.netmask_ext, :lvl => level)
     ipnet.save
     insert_element(ipnet, parent)
   end
 end
 
 def valid_children_size?(anArray, netsize)
   anArray.each do |a|
     addr = a.ipaddr+" "+a.netmask
     netaddr_obj = NetAddr::CIDR.create(addr)
     if netaddr_obj.size > netsize
       return false
     end
   end
   return true
 end
 
 def return_array_of_children_between_ipnets(first,last)
    arr = Array.new
    erster = NetAddr::CIDR.create("#{first.ipaddr} #{first.netmask}")
    letzter = NetAddr::CIDR.create("#{last.ipaddr} #{last.netmask}")
     while erster.ip != letzter.ip
        i = Ipnet.find(:first, :conditions => ["ipaddr = ? and netmask = ? and parent_id = ?", erster.ip, erster.netmask_ext, first.parent_id]) 
        arr << i if i
        erster = NetAddr::CIDR.create("#{erster.next_ip} #{erster.netmask_ext}")
     end
    arr << last
    return arr
 end

 def search_successor_of_ipnet(ipnet)
    search_obj = NetAddr::CIDR.create("#{ipnet.ipaddr} #{ipnet.netmask}")
    last_obj = NetAddr::CIDR.create("#{search_obj.last} #{ipnet.netmask}") ##Ist das letzte CIDR-Objekt des Netzes
    i = nil
    if search_obj.next_ip != last_obj.next_ip
      while search_obj.ip != last_obj.next_ip ##last_obj.next_ip ist IP im neuen Netz -> damit while bis 255 sucht
        search_obj = NetAddr::CIDR.create("#{search_obj.next_ip} #{search_obj.netmask_ext}")
        if (i = Ipnet.find(:first, :conditions => ["ipaddr = ?, netmask = ?, lvl = ?", search_obj.ip, search_obj.netmask_ext, ipnet.lvl]))
          return i
        end
      end #while   
    end #if
 end #methode
 
 def sort_ipnets(anArrayOfIpnets)
   temp_arr = Array.new ##Array der Ip-Adressen+ index unsortiert
   ipaddr_arr = Array.new ##Array nur für die IPs -> zum Sortieren durch NetAddr
   return_arr = Array.new ##Array, welches zurückgegeben wird
   anArrayOfIpnets.each_with_index do |a,i|
    temp_arr << [a.ipaddr,i] #erstellt array [ipadresse, index] -> index zum auslesen der unsortieren position später
    ipaddr_arr << a.ipaddr #Nur IPs anhängen
   end
   ipaddr_arr = NetAddr.sort(ipaddr_arr) #sortiert Array nach IPs  
   ipaddr_arr.each do |ipaddr| #durchlaufe alle sortierten IPs
     aktuell = temp_arr.assoc(ipaddr) #gibt ein array in Form [ipaddr,index] unsortiertem temp_arr zurück -> assoc ist hier die eierlegende Wollmilchsau, sofern man nur 2 Werte im Array stehen hat ;-)
     index = aktuell.last ## index des unsortierten Ipnetobjektes auslesen auslesen
     return_arr << anArrayOfIpnets.at(index) ##return_arr mit Ipnetobjekt an stelle alt[index] füllen
   end
   return return_arr
 end
 
# def search_ipnet_space(parent_ipnet, count)
#   puts "NACH FREIEN IPs SUCHEN!!!"
#   parent = Ipnet.find(parent_ipnet)
#   cidr_start = NetAddr::CIDR.create("#{parent.ipaddr} #{parent.netmask}")
#   #Suche erste freie IP
#   while a = Ipnet.find_by_ipaddr(cidr_start.next_ip)
#     puts "a gefunden? #{a} #{a.class}"
#     cidr_start = NetAddr::CIDR.create("#{a.ipaddr} #{a.netmask}")
#   end
#   #Prüfe, ob gewünschter Adressraum frei ist  ABBRUCHBEDINGUNG??? NETZ VOLL? wie realisieren?
#   gefunden = false
#   while gefunden == false
#     cidr_ende = cidr_start.next_ip(:Bitstep => count, :Objectify => true)
#     ipnets = NetAddr.range(cidr_start, cidr_ende, :Inclusive => true) 
#     
#     belegt = false
#     for ipnet in ipnets
#       if Ipnet.find(:all, :conditions => ['ipaddr = ? AND netmask =?', ipnet.ip, ipnet.netmask_ext])
#         belegt = true
#       end # if
#     end # for
#     if belegt == false
#       gefunden = true
#     end #if
#     
#   end #while
#   return cidr_start   
# end #def
     
end
