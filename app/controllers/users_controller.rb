class UsersController < ApplicationController
  layout "ipnets"
  
  # GET /users/welcome
  def welcome
    # Platzhalter für Startbildschirm der Application ohne Authentisierung
  end
  
  # GET /users
  def index
    @users = User.find(:all, :order => 'lastname')
    
    respond_to do |format|
      format.html
    end
  end
  
  # GET /users/new
  def new
    @user = User.new
    @roles = Role.find(:all, :order => "role_name").map {|r| [r.role_name, r.id]}
    respond_to do |format|
      format.html
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @roles = Role.find(:all, :order => "role_name").map {|r| [r.role_name, r.id]}
    
    respond_to do |format|
      format.html
    end
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        flash[:notice] = "Neuer Nutzer #{@user.user_name} wurde angelegt!"
        user_info "Neuer Nutzer #{@user.user_name} wurde mit Rolle #{@user.role.role_name} angelegt."
        format.html { redirect_to(@user) }
      else
        flash[:error] = "Neuer Nutzer konnte nicht angelegt werden!"
        user_error "Neuer Nutzer #{@user.user_name} konnte nicht angelegt werden."
        @roles = Role.find(:all, :order => "role_name").map {|r| [r.role_name, r.id]}
        format.html { render :action => "new" }
      end
    end
  end
  
  # GET /users/1
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  # PUT /users/1  
  def update
    # Testen, ob die Parameter valid sind
    user_name_length = ((params[:user][:user_name].length >= 6) and (params[:user][:user_name].length <= 20))
    if params[:user][:password] == '' then
      password_length = true
      password_patterns = true
    else
      password_length = ((params[:user][:password].length >= 8) and (params[:user][:password].length <= 20))
      password_patterns = (params[:user][:password] =~ /(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/)
    end
    v = (password_length and password_patterns and user_name_length)
        
    @user = User.find(params[:id])
    
    respond_to do |format|
      if v and params[:user][:password] == ''  # update_attributes schlägt fehl ohne Passwort
        @user.update_attribute(:user_name, params[:user][:user_name])
        @user.update_attribute(:lastname, params[:user][:lastname])
        @user.update_attribute(:firstname, params[:user][:firstname])
        @user.update_attribute(:behoerde, params[:user][:behoerde])
        @user.update_attribute(:email, params[:user][:email])
        @user.update_attribute(:role_id, params[:user][:role_id])
        flash[:notice] = "User #{@user.user_name} wurde ohne Passwort aktualisiert."
        user_info "User #{@user.user_name} wurde ohne Passwort aktualisiert."
        format.html { redirect_to(@user) }
      elsif v and @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.user_name} wurde mit neuem Passwort aktualisiert."
        user_info "User #{@user.user_name} wurde mit neuem Passwort aktualisiert."
        format.html { redirect_to(@user) }
      else
        flash[:error] = "User #{@user.user_name} konnte nicht aktualisiert werden!"
        user_error "User #{@user.user_name} konnte nicht aktualisiert werden!"
        @roles = Role.find(:all, :order => "role_name").map {|r| [r.role_name, r.id]}
        format.html { render :action => "edit" }
      end
    end  
  end
  
  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    name = @user.user_name
    delete = true
    if @user.id == @actual_user.id
      delete = false
      flash[:error] = "Sie können sich nicht selbst löschen!"
    elsif @user.role.role_name == 'Administrator'
      count = User.count(:conditions => "role_name = 'Administrator'", :include => :role)
      if count == 1
        delete = false
        flash[:error] = "Sie können nicht den letzten Administrator des Systems löschen!"
      end
    end
    if delete
      @user.destroy
      flash[:notice] = "User #{name} wurde gelöscht!"
      user_warn "User #{name} wurde gelöscht!"
    end
    
    respond_to do |format|
      format.html { redirect_to(users_url) }
    end  
  end

  # GET /users/login => Login-Screen
  # POST /users/login => Authentisierung
  def login
    puts "Usercontroller Login:"
    puts "params? #{params}"
    respond_to do |format|
      if request.post?
        password_ok, active = false
        uname = params[:user][:user_name]
        @user = User.find(:first, :conditions =>[ "user_name = ?", uname])
        if @user then
          password_ok = @user.password_is? params[:user][:password]
          active = @user.active?
        end
        
        if password_ok and active
          @user.userdata.update_attribute(:last_login, Time.now.gmtime)
          @user.userdata.update_attribute(:password_faults, 0)
          session[:uid] = @user.id
          session[:time] = Time.now.gmtime.to_a.join(";")
          user_info "Eingeloggt unter Nutzername: #{uname}"
          if @user.is_admin? then
            format.html { redirect_to(users_url) }
          else
            #format.html { redirect_to(@settings["default_page"])}
            format.html { redirect_to(:controller => 'ipnets', :action => 'index')}
          end
        else
          if !@user
            flash[:error] = 'Username oder Passwort falsch!'
            user_error "Login-Versuch mit unbekanntem Nutzernamen: #{uname}"
            return
          elsif !active
            flash[:error] = 'Account ist deaktiviert! Bitte wenden Sie sich an den Systemadministrator!'
            user_error "Login-Versuch bei deaktiviertem Account! Nutzer: #{uname}"
            return             
          else
            increase_password_faults_and_eventually_deactivate(@user)
            flash[:error] = 'Username oder Passwort falsch!'
            user_error "Falsches Passwort für User: #{@user.user_name}"
            return
          end
        end
      else # request ist GET, Leerobjekt anlegen
        @user = User.new
        format.html
      end
    end
  end

  # GET /users/logout
  def logout
    clear_session("Manuelles Logout erfolgreich")
  end
  
  # POST /users/update_password
  def update_password
    @user = User.find(params[:id])
    udata = Userdata.find_by_user_id(@user.id)
    error = Array.new
    
    if @actual_user.id != @user.id
      error << "Fehlerhafte User-ID!\l\n"
    elsif !@actual_user.password_is?(params[:old_password])
      error << "Bisheriges Passwort falsch!\l\n"
    elsif params[:password] != params[:password_confirmation]
      error << "Passwort und dessen Wiederholung ungleich!\l\n" 
    elsif !@actual_user.last_passwords_differ_from?(params[:password])
      error << "Passwort muss von den letzten 3 Passwörtern verschieden sein!\l\n" 
    end
    
    if error.empty?
      if set_passwords(udata, @user.password_salt, @user.password_hash)
        @user.password = params[:password]
        @user.save
      end
    end
    
    @user.errors.each do |k,v|
      error << k + " " + v + "\l\n"
    end
    
    respond_to do |format|
      if error.empty?
        flash[:notice] = "Ihr Passwort wurde aktualisiert!"
        user_info "Passwort wurde aktualisiert"
        format.html {redirect_to :action => 'show', :id => @user.id}
      else
        flash[:error] = error
        user_error "Fehler bei der Passwortaktualisierung"
        format.html {redirect_to :action => 'change_password', :id => @actual_user.id, :method => 'get'}
      end
    end

  end
  
  # GET /users/change_password/:id
  def change_password
    begin
      @user = User.find(params[:id])
      if @user.id == @actual_user.id then
        alles_ok = true
      else
        alles_ok = false
      end
    rescue
      
    end
    
    respond_to do |format|
      if alles_ok
        format.html
      else
        flash[:error] = "Fehlerhafte User-ID! Sie wurden ausgeloggt!"
        user_error "Zugriffsversuch auf fremde Userdaten"
        format.html {redirect_to :action => 'logout'}
      end
    end
  
  end
  
  # GET /users/my_settings/:id
  def my_settings
    begin
      @user = User.find(params[:id])
      if @user.id == @actual_user.id then
        alles_ok = true
      else
        alles_ok = false
      end
    rescue
      
    end
    
    respond_to do |format|
      if alles_ok
        format.html
      else
        flash[:error] = "Fehlerhafte User-ID! Sie wurden ausgeloggt!"
        user_error "Zugriffsversuch auf fremde Userdaten"
        format.html {redirect_to :action => 'logout'}
      end
    end
    
  end
  
  def update_my_settings
    begin
      @user = User.find(params[:user][:id])
      if @user.id == @actual_user.id then
        alles_ok = true
      else
        alles_ok = false
      end
    rescue
      
    end

    respond_to do |format|
      if alles_ok
        if @user.update_attribute(:behoerde, params[:user][:behoerde]) and @user.update_attribute(:email, params[:user][:email])
          flash[:notice] = "Ihre Daten wurden aktualisiert!"
          format.html {redirect_to :action => 'show', :id => @user.id }
        else
          flash[:error] = "Fehler beim Abspeichern! Bitte erneut versuchen!"
          user_error "Fehler beim Abspeichern der aktualisierten Nutzerdaten (Selbstadministration)"
          format.html {redirect_to :action => 'my_settings', :id => @user.id }
        end
      else
        flash[:error] = "Fehlerhafte User-ID! Sie wurden ausgeloggt!"
        user_error "Zugriffsversuch auf fremde Userdaten"
        format.html {redirect_to :action => 'logout'}
      end
    end   
  end 
  
  def recover_password
    @user = User.find_by_user_name(params[:user_name])
    if request.post?
      if @user
        NoticeMailer.deliver_inform_user(@user, "IP-DB: Ihre Accountdaten", "Ihre Benutzerdaten lauten: USERNAME: #{@user.user_name} PASSWORT: #{}muss noch implementiert werden Bitte löschen Sie diese Email unwiderruflich und stellen Sie sicher, dass Sie Ihr Passwort sicher verwahren. Vielen Dank.")
        flash[:notice] = "Eine Email mit Ihren Daten wurde Ihnen zugesendet."
        redirect_to(:action => 'login')
      else
        flash[:error] = "Der angegebene Nutzer wurde nicht gefunden, bitte wenden Sie sich an einen Administrator."
      end
    else #GET
      respond_to do |format|
        format.html
      end #respond
    end #if  
  end #def


  def administrate_users
    @users = User.find(:all, :order => 'lastname')
    
    respond_to do |format|
      format.html
    end
  end
  
  def confirm_account(key)
    if user = User.find(:first, :include => :userdata, :conditions => ["userdatas.password3_hash = ?", key])
      #user.userdata.update_attribute(:deactivated, false) --> de_or_activate(user, false, "User selbst freigeschaltet")
      user.userdata.update_attribute(:deactivation_reason, "Wartet auf Freischaltung durch Administrator")
      user.userdata.update_attribute(:deactivation_date, Time.now.gmtime)
      flash[:notice] = "Ihr Account wurde erfolgreich bestätigt, bitte warten Sie auf die Freischaltung durch einen Administrator"
      redirect_to(:action => 'welcome')
    else
    puts "noch nichts"
    end
  end
  
  def toggle_deactivation
    @user = User.find(params[:id])
    
    # Ändert den Status des Users
    @user.userdata.deactivated ? @user.activate("Durch Administrator freigegeben") : @user.deactivate("Durch Administrator gesperrt")    
  
    flash[:notice] = "Userdaten wurden erfolgreich geändert."
    redirect_to(:action => 'administrate_users')
  end
  
########### P R I V A T E ############  
  
  private
  
  def set_passwords(udata, pass_salt, pass_hash)
    udata.password3_salt = udata.password2_salt
    udata.password2_salt = udata.password1_salt
    udata.password1_salt = pass_salt
    udata.password3_hash = udata.password2_hash
    udata.password2_hash = udata.password1_hash
    udata.password1_hash = pass_hash
    udata.save
  end
  
  def increase_password_faults_and_eventually_deactivate(user)
    user.userdata.update_attribute(:password_faults, (user.userdata.password_faults + 1))
    la = @settings["login_attempts"]
    if user.userdata.password_faults >= la
      user.deactivate("Mehr als #{la} fehlgeschlagene Loginversuche")
      user_error "Mehr als #{la} fehlgeschlagene Loginversuche"
    end
  end 
  
end #Usercontroller
