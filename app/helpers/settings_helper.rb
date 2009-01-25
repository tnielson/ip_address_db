module SettingsHelper
  
    def select_options_jn(selected)
    str = String.new
    if selected == "Ja" then
      str = '<option selected="selected">Ja</option><option>Nein</option>'
    else
      str = '<option>Ja</option><option selected="selected">Nein</option>'
    end
    return str
  end
  
end
