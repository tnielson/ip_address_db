# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_title_helper
    return @page_title ? @page_title : 'horibo.de: ' + controller_name
  end
  
  def menue_link_helper(name, controller, action)
    start = '<li>'
    stop = '</li>'
    link = link_to(link_to(name, :controller => controller, :action => action))
    return start + link + stop
  end
  
  # Helper Horibo Login Tool
  def int_to_jn(int)
    if int == 0 then
      return "Nein"
    else
      return "Ja"
    end
  end

  # helper zur Erstellung des Titels einer Seite
  def appl_title(contr)
    'SPNSH::Log-DB::' + contr.controller_name + '::' + contr.action_name
  end
  
  def my_submit_tag(value = "Save Changes", options ={})
    options.stringify_keys!
    
    if confirm =options.delete("confirm") then
      options["onclick"] = "return confirm('#{confirm}');"
    end
    
    tag :input, { "type" => "submit", "name" => "commit", "value" => value }.update(options.stringify_keys)
  end
  
  def sort_th_class_helper(param)
    result = 'class = "sort_up"' if params[:sort] == param
    result = 'class = "sortdown"' if params[:sort] == param + "_reverse"
    return result
  end
  
  def sort_link_helper(text, param)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
      :url => {:action => 'list', :params => params.merge({:sort => key, :page => nil}) },
      :update => 'list',
      :before => "Element.show('waiting')",
      :success => "Element.hide('waiting')"
    }
    html_options = {
      :title => "Nach diesem Feld sortieren",
      :style => "text-align: center; font-weight: bold; margin: 0; padding: 5px;",
      :href => url_for( :action => 'list', :params => params.merge({ :sort => key, :page => nil }) )
    }
    link_to_remote(text, options, html_options)
  end
  
def showpath(selected)
    modelname = get_modelname_of_current_controller
    
    if selected
      selected_object = eval(modelname).find(selected)
      temparray = selected_object.self_and_ancestors()
      puts "temparray sieht so aus: #{temparray}"
     
      count = 0
      temparray.each do |arr|
        obj = eval(modelname).find(:first, :conditions => ['name = ?', arr.name])
        temparray[count] = (link_to "#{arr.name}", {:action => "index", :current_object => obj})
        count += 1
      end
      
      return temparray.join(' / ')
    else
      flash[:error] = "Fehler - kann keinen Pfad erstellen"
    end
  end

  ##Gibt das aus dem Controller referenzierte Model als String zurück
  def get_modelname_of_current_controller
    str = controller.controller_name
    puts "----------------- Hier der String: #{str}"
    modelname = str[0..str.length-2].capitalize
    puts "und der entstandene modelname #{modelname}"
    return modelname
    
  end

end
