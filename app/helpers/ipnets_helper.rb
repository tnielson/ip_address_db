module IpnetsHelper
   # ipnetselect is the id of currently selected ipnet
  def showipnet(ipnetselect, sort)
    if ipnetselect
      @ipnetselect = Ipnet.find(ipnetselect) #Sucht das geklickte Element
      selectpath = @ipnetselect.self_and_ancestors #Aktuell geklickter Pfad
    else
      @ipnetselect = nil #Wenn kein Element angeklickt wurde -> Pfad leer
      selectpath = []
    end
    parents = (selectpath.map{|m| m.parent}+[@ipnetselect]).uniq-[nil] #ergibt wieder Pfad?
    parents_sql_filter = parents.empty? ? '' : " OR parent_id IN (#{parents.map{|p| p.id}.join(',')})"
  
    #suche nur die ipnets, die geöffnet sein müssen
    allipnets = Ipnet.find(:all, :conditions => "(parent_id IS NULL #{parents_sql_filter})", :order => 'lft')

######Sortierung des Arryays allipnets nach dem übergebenen Parameter sort
    ## Ist auch möglich, in einer Condition zu schreiben, wäre aber unübersichtlich m.E.    
    
   ## Ich muss die children aus dem allipnets Array raussuchen, untereinander sortieren (am Ende zurückschreiben)
   ## children = Ipnet.find_all_by_parent_id(@ipnetselect.id) ##Sucht alle children des geklickten Elementes
   ## children = children.sort_by{ |element| element['name'] }   #Sortiert die children nach 'name'

   ## Positionen der children im allipnets-Array suchen und mit sortiertem children-Array überschreiben
   ## p_index = allipnets.index(@ipnetselect)  ##Liefert Index des parents -> parent+1 = 1. child
   ## allipnets[p_index+1 .. p_index+1+children.count] = children.to_a  ##Überschreibt Array mit sortierten children an der richtigen Stelle
   
    children = Ipnet.find_all_by_parent_id(@ipnetselect.id)
    p_index = allipnets.index(@ipnetselect)

    if sort == 'name'
      puts "Sortierung nach Name"
      children = children.sort_by{ |element| element['name'] }
      allipnets[p_index+1 .. p_index+children.length] = children.to_a
    elsif sort == 'ipaddr'
      puts "Sortierung nach ipaddr"
      children = children.sort_by{ |element| element['ipaddr'] }
      allipnets[p_index+1 .. p_index+children.length] = children.to_a
   end
####Sortierung beendet#####   

    #Markieren, an welchen Stellen die HTML-Listen zu öffnen und zu schließend sind
    @ipnets = []
    allipnets.each_index { |i|
        @ipnets[i] = {:level => allipnets[i].lvl, 
                     :name  => allipnets[i].name,
                     :id => allipnets[i].id,
                     :children_count => allipnets[i].children_count
                     }
        @ipnets[i][:current_ipnet] =  allipnets[i] == @ipnetselect
    }
    allipnets[1..-1].each_index { |i|
      @ipnets[i][:open] = @ipnets[i][:level] > @ipnets[i-1][:level]
      @ipnets[i][:close] = [0, @ipnets[i][:level] - @ipnets[i+1][:level]].max
    }
    @ipnets.first[:open] = true
    @ipnets.last[:open] = false
    @ipnets.first[:close] = 0
    @ipnets.last[:close] = 1
    
    render 'ipnets/showipnet', :sort => sort
  end
  
#  def showpath(selected_net)
#    puts "vorerst mal session ausgeben: #{session[:current_ipnet]}"
#    puts "Ipnets Helper showpath: selected_net=? #{selected_net}"
#    if selected_net
#      selected_net = Ipnet.find(selected_net)
#      temparray = selected_net.self_and_ancestors()
#     
#      count = 0
#      temparray.each do |arr|
#        selected = Ipnet.find(:first, :conditions => ['name = ?', arr.name])
#        temparray[count] = (link_to "#{arr}", {:action => "index", :current_ipnet => selected})
#        count += 1
#      end
#      
#      return temparray.join(' / ')
#    else
#      return "Fehler - kann keinen Pfad erstellen"
#    end
#  end
  
  
end
