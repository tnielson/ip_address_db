class SettingsController < ApplicationController
  layout "ipnets"
     
  # GET /setting
  def index 
    @settings = Setting.get_settings
 
    respond_to do |format|
      format.html
    end
  end

  # GET /setting/edit
  def edit
    @settings = Setting.get_settings
    
    respond_to do |format|
      format.html
    end
  end

  # PUT /setting/update
  def update
    ok = true
    # Zunaechst die Standardwerte loeschen, da diese nicht in der DB gefunden werden
    params.delete(:commit)
    params.delete(:authenticity_token)
    params.delete(:action)
    params.delete(:controller)
    # Update starten
    params.each do |k,v|
      s = Setting.find_by_key(k)
      if v == "Ja" then
        s.value = 1
      elsif v == "Nein"
        s.value = 0
      else
        s.value = v
      end
      ok = false unless s.save
    end
    
    respond_to do |format|
      if ok
        flash[:notice] = "Globale Einstellungen wurden aktualisiert."
        format.html { redirect_to(:action => "index") }
      else
        flash[:error] = "Fehler beim Speichern der globalen Einstellungen!"
        format.html { redirect_to(:action => "edit") }
      end
    end  
  end
  
end
