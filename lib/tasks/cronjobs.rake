namespace :user do
  desc "Executes cronjobs such as 'remind users 3 days before deactivation'"
  task(:cronjob => :environment) do
    
    ## Variablen hier deklarieren und nur eine find_with_condition im Usermodel integrieren? Wäre besser!
      rdbd = Setting.find_by_key("remind_days_before_deactivation").value
      remind_days = rdbd.days      
      
      daid = Setting.find_by_key("deactivate_after_inactive_days").value
      expire_days = daid.days

      duadd = Setting.find_by_key("delete_deactivated_users_after_deactivated_days").value
      deletion_days = duadd.days
      
      pea = Setting.find_by_key("password_expires_after").value
      password_expire_days = pea.days
      
      password_expire_notice = 7.days
      
    ##Password aging: Benachrichtige User vor Ablaufen des Passwortes
    if Setting.find_by_key("enable_password_aging").value = 1
      puts "User, deren PW älter ist als: #{Time.now - password_expire_days + password_expire_notice} werden benachrichtigt"
      query = User.find(:all, :include => :userdata, :conditions => [("userdatas.password_updated_on <= ? and userdatas.deactivated = ?"), Time.now - password_expire_days + 7.days, false])
      puts query
      if query
        for user in query do
          puts user.user_name
          puts user.userdata.last_login
          puts "IP-DB: Ihr Passwort läuft in #{((user.userdata.last_login - (Time.now - password_expire_days))/1.days).round} Tagen ab."
          #NoticeMailer.deliver_inform_user(user, "IP-DB: Ihr Passwort läuft in #{((user.userdata.last_login - (Time.now - password_expire_days))/1.days).round} Tag(en) ab.", "Ihr Passwort wird am X ablaufen. Ein Ablaufen des Passwortes kann eine Deaktivierung Ihres Accounts nach sich ziehen. Bitte setzen Sie vor Ablauf des Datums ein neues, sicheres Passwort.")
        end  
      end 
    end
    
    ##Password aging: Deaktiviere User deren Passwort abgelaufen ist
    if Setting.find_by_key("enable_password_aging").value = 1
      puts "User, deren PW älter ist als: #{Time.now - password_expire_days} werden deaktiviert"
      query = User.find(:all, :include => :userdata, :conditions => [("userdatas.password_updated_on <= ? and userdatas.deactivated = ?"), Time.now - password_expire_days, false])
      puts query
      if query
        for user in query do
          puts user.user_name
          puts user.userdata.last_login  
          if user.userdata.deactivated == false && user.deactivate_user("CJ: Passwort abgelaufen")
            #NoticeMailer.deliver_inform_user(user, "IP-DB: Deaktivierung Ihres Accounts", "Ihr Account wurde am #{Time.now} deaktiviert, da Ihr Passwort abgelaufen ist. Zur erneuten Freischaltung wenden Sie sich bitte an einen Administrator.")
            #NoticeMailer.deliver_inform_admin("IP-DB: Deaktivierung des Users #{user.user_name} - Password Aging", "Der Account des Users #{user.user_name} wurde aufgrund eines abgelaufenen Passwortes deaktiviert. Bitte überprüfen Sie den Grund dafür und treffen entsprechende Maßnahmen.")
          end
        end  
      end    
    end
    

    ##Login Aging: Benachrichtige User bevor sie deaktiviert werden und eventuell Admin
    if Setting.find_by_key("remind_inactive_users").value = 1
      puts "User, deren letzter Login älter ist als: #{Time.now - expire_days + remind_days} werden benachrichtigt, bevor sie deaktiviert werden"
      query = User.find(:all, :include => :userdata, :conditions => [("userdatas.last_login <= ? and userdatas.deactivated = ?"), Time.now - expire_days + remind_days, false])
      for user in query do
        #NoticeMailer.deliver_inform_user(user, "IP-DB: Deaktivierung Ihres Accounts in #{(((user.userdata.last_login - (Time.now - expire_days))/1.days).round)} Tag(en)", "Bitte loggen Sie sich regelmäßig in die IP-DB ein, ansonsten wird Ihr Account auf Basis der Sicherheitsrichtlinien des Konzerns nach längerer Inaktivität deaktiviert werden. Sollten Sie die Dienste der IP-DB nicht mehr benötigen oder sollten Sie mittlerweile in einer anderen Abteilung sein, so informieren Sie bitte umgehend den Administrator des Systems.")
      end     
    end
    
    #Login - Aging: Deaktiviere inaktive User (und benachrichtige evtl Admin)
    if Setting.find_by_key("deactivate_inactive_users").value = 1
      puts "User, deren letzter Login älter ist als: #{Time.now - expire_days} werden deaktiviert"
      query = User.find(:all, :include => :userdata, :conditions => [("userdatas.last_login <= ? and userdatas.deactivated = ?"), Time.now - expire_days, false])
      puts query
      if query
        for user in query do
          puts user.user_name
          puts user.userdata.last_login
          #NoticeMailer.deliver_inform_user(user, "IP-DB: Deaktivierung Ihres Accounts", "Ihr Account wurde aufgrund längerer Inaktivität deaktiviert. Zur erneuten Freischaltung wenden Sie sich bitte an den Administrator.")
          #NoticeMailer.deliver_inform_admin("IP-DB: Deaktivierung des Users #{user.user_name} - Login Aging", "Der Account des Users #{user.user_name} wurde aufgrund längerer Inaktivität deaktiviert. Bitte überprüfen Sie den Grund dafür und treffen entsprechende Maßnahmen.")
          #user.deactivate_user("User zu lange inaktiv")
        end  
      end    
    else
      #NoticeMailer.deliver_inform_admin("IP-DB: Inaktivität des Users #{user.user_name} - Login Aging", "Der Users #{user.user_name} weist Inaktivität auf. Bitte überprüfen Sie den Grund dafür und treffen entsprechende Maßnahmen.")
    end

    
    ##Benachrichtige User bevor sie gelöscht werden und evtl Admin
    if Setting.find_by_key("delete_deactivated_users").value = 1
      puts "User, deren Deaktivierungsdatum älter ist als: #{Time.now - deletion_days + 7.days} werden benachrichtigt"
      query = User.find(:all, :include => :userdata, :conditions => [("userdatas.deactivation_date <= ? and userdatas.deactivated = ?"), Time.now - deletion_days + 7.days, true])
      for user in query do
        #NoticeMailer.deliver_inform_admin("IP-DB: Sie werden in Kürze vom System entfernt werden", "Bitte lassen Sie Ihren Account durch einen Administrator freischalten, ansonsten wird Ihr Account auf Basis der Sicherheitsrichtlinien des Konzerns nach längerer Inaktivität gelöscht werden. Sollten Sie die Dienste der IP-DB nicht mehr benötigen oder sollten Sie mittlerweile in einer anderen Abteilung sein, so informieren Sie bitte umgehend den Administrator des Systems.")
        if Setting.find_by_key("remind_admin_before_deletion").value = 1
          #NoticeMailer.deliver_inform_admin("IP-DB: Baldige Löschung des Users #{user.user_name} - Deactivation Aging", "Der Account des Users #{user.user_name} wird aufgrund längerer Inaktivität gelöscht werden. Bitte überprüfen Sie den Grund dafür und treffen entsprechende Maßnahmen.")
        end
      end
    else
      #NoticeMailer.deliver_inform_admin("IP-DB: User #{user.user_name} zu lange deaktiviert - Deactivation Aging", "Der Account des Users #{user.user_name} befindet sich zu lange im Status 'deaktiviert' und sollte in spätestens X Tagen vom System entfernt werden. Bitte überprüfen Sie den Grund dafür und treffen entsprechende Maßnahmen.")
    end
    
    ##Lösche deaktivierte User
    if Setting.find_by_key("delete_deactivated_users").value = 1
      query = User.find(:all, :include => :userdata, :conditions => [("userdatas.deactivation_date <= ? and userdatas.deactivated = ?"), Time.now - deletion_days, true])
      puts "User, deren Deaktivierungsdatum vor dem #{Time.now - deletion_days} liegt, werden gelöscht"
      if query
        for user in query do
          puts user.user_name
          puts user.userdata.deactivation_date
          #NoticeMailer.deliver_inform_user(user, "IP-DB: Sie wurden vom System entfernt", "Bitte lassen Sie Ihren Account durch einen Administrator freischalten, ansonsten wird Ihr Account auf Basis der Sicherheitsrichtlinien des Konzerns nach längerer Inaktivität gelöscht werden. Sollten Sie die Dienste der IP-DB nicht mehr benötigen oder sollten Sie mittlerweile in einer anderen Abteilung sein, so informieren Sie bitte umgehend den Administrator des Systems.")
          #NoticeMailer.deliver_inform_admin("IP-DB: Löschung des Users #{user.user_name} - Deactivation Aging", "Der Account des Users #{user.user_name} wurde aufgrund zu langer Zeit im Status 'deaktiviert' gelöscht.")
          #user.destroy
        end
      end  
    else
      #NoticeMailer.deliver_inform_admin("IP-DB: Bitte löschen Sie den User #{user.user_name} - Deactivation Aging", "Der Users #{user.user_name} befindet sich zu lange im Status 'deaktiviert'. Bitte überprüfen Sie den Grund dafür und treffen entsprechende Maßnahmen.")
    end

  end #task
end #namespace