class UserdataController < ApplicationController
  layout "user"
  
  def new_user_data(user)
    udata = Userdata.new
    udata.user_id = user.id
    udata.password1_salt = user.password_salt
    udata.password1_hash = user.password_hash
    
    if udata.save
      flash[:info] = "neue Nutzerdaten erfolgreich angelegt"
    else
      flash[:error] = "neue Nutzerdaten konnten nicht angelegt werden"
    end
    
  end
  
  def update_user_login(user)
    udata = find_userdata(user)
    udata.last_login = Time.now
    udata.save
  end
  
  def update_user_data(user, deac, deac_reason, pass_salt, pass_hash, startpage)
    udata = find_userdata(user)  
    if deactivation_changed?(udata, deac)
      udata.deactivation_date = Time.now
      udata.deactivated = deac
    end
    udata.deactivation_reason = deac_reason 
    udata.default_startpage = startpage 
  end
  
  def destroy_user_data(user)
    if user.name == 'Superadmin'
      flash[:error] = "Daten des Superusers können nicht gelöscht werden"
    else
      udata = Userdata.find(:first, :conditions => ["user_id = ?", user.id])
      udata.destroy
      flash[:info] = "Der Datensatz wurde erfolgreich gelöscht"
    end
  end

  
  
######### P R I V A T E ################  
  
  private

  def find_userdata(user)
    return Userdata.find(:first, :conditions => ["user_id = ?", user.id]) 
  end
  
  def deactivation_changed?(udata, deac)
    if udata.deactivated != deac
      return true
    end   
  end 
  
end
