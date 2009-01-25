class UserActionController < ActionController::Base

  before_filter :authentication_filter

  # User-Logging einrichten
  # und Standard-Variablen setzen
  def initialize
    # User-Logging
    logfile = File.open(RAILS_ROOT + '/log/user.log', 'a')
    logfile.sync = true
    @@user_log = AuditLogger.new(logfile)
    # Standard-Variablen
    @settings = Setting.get_settings
  end
  
  def set_locale
    locale = params[:locale] || 'de'
    I18n.locale = locale
    I18n.load_path += Dir[ File.join(RAILS_ROOT, 'lib', 'locale', '*.{rb,yml}') ]
  end
  
  def user_info(msg)
    message = " [#{@actual_user.user_name}]: " + msg
    @@user_log.info(message)
  end
  
  def user_error(msg)
    message = " [#{@actual_user.user_name}]: " + msg
    @@user_log.error(message)
  end
  
  def user_warn(msg)
    message = " [#{@actual_user.user_name}]: " + msg
    @@user_log.warn(message)
  end

private
  # Weist jedem Controller-Objekt die Variable @user zu und
  # testet, ob der identifizierte User die Berechtigung
  # für die aufgerufene Action hat
  def authentication_filter
    # Session Timeout überprüfen und neu setzen
    
    if session[:uid] and session_timeout?
      puts "App-Controller: Session Timeout"
      @actual_user = User.find(session[:uid])
      clear_session("Session-Timeout. Sie wurden automatisch ausgelogt")
    else
    # Aufrufenden User identifizieren oder Gast-User erzeugen
      if session[:uid] then
        puts "App-Controller: Neuer User wird gesetzt (session[:uid] existiert)"
        @actual_user = User.find(session[:uid])
        puts "also steht in actual_user.user_name nun: #{@actual_user.user_name}"
      else
        puts "App-Controller: session[:uid] nil -> Neuer Gast wird angelegt"
        @actual_user = User.new
        @actual_user.user_name = "Gast"
        role = Role.find_by_role_name('Gast')
        @actual_user.role_id = role.id
      end
      # Time-Objekt wird auf UTC gesetzt (gmtime). UTC kennt keine Sommer-/Winterzeit
      puts "App-Controller: session[:time] wird neu gesetzt"
      session[:time] = Time.now.gmtime.to_a.join(";")
      # Testen, ob User die Berechtigung für die aufgerufene Action hat
      if @actual_user.has_permission?(controller_class_name, action_name)
        puts "App-Controller: User besitzt Berechtigungen und Navigation wird gesetzt"
        #set_navigation       
        return
      else
        # User hat keine ausreichende Berechtigung
        flash[:notice] = "Sie haben nicht die Berechtigung für den Zugriff auf diese Seite!"
        user_warn "Fehlende Berechtigung für: #{controller_class_name}::#{action_name}"
        puts "#{@actual_user.user_name} - Fehlende Berechtigung für: #{controller_class_name}::#{action_name} -> Redirect back or path"
        redirect_back_or(:controller => 'users', :action => 'login')
      end
    end  
  end
  
  def session_timeout?
    puts "App-Controller: Session Timeout? Überprüfung"
    result = true
    t = Time.now.gmtime
    sto = @settings["session_timeout"]
    if session[:time] then
      a = session[:time].split(";")
      st = Time.gm(*a)
      result = false if (t - st) < sto
    end
    puts "App-Controller: Session Timeout? Ergebnis: #{result}"
    return result
  end
  
  def clear_session(reason)
    puts "App-Controller: clear_session"
    session[:uid] = nil
    session[:time] = nil
    flash[:notice] = reason
    user_info reason
    redirect_to(:controller => "users", :action => "welcome")
  end
  
  def redirect_back_or(path)
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to path
    end
  end
  
  def set_navigation()
    puts "--------------------------------------------ICH SETZE DIE NAVI NEU!"
    if params[:current_ipnet]
      puts "-----------SESSION: params[:ipnet] gibt es: #{params[:current_ipnet]}, Class? #{params[:ipnet].class} und wird in session geschrieben"
      session[:current_ipnet] = Ipnet.find(params[:current_ipnet]).id
      session[:parent_ipnet] = Ipnet.find(params[:current_ipnet]).parent_id
    else
      if session[:current_ipnet]
        puts "-----------SESSION: Gleich geblieben, kein neues Netz"
      else
        puts "-----------SESSION: current wird zu root Standard: "
        root = Ipnet.find(:first, :conditions => "name = 'root'")
        session[:current_ipnet] = root.id
        session[:parent_ipnet] = root.id
        puts "-----------SESSION: current wird zu root Standard: #{session[:current_ipnet]}, Class? #{session[:current_ipnet].class}"
      end #if2
    end #if1
    
    if params[:sort]
      session[:sort] = params[:sort]
    else
      session[:sort] = 'name'
    end
  end #def

end

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < UserActionController
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '584987183a04cb1570a06a8bed0e5abc'
  
  rescue_from ActiveRecord::RecordNotFound, :with => :show_404
  
  def show_404
    puts "App-Controller: rescue -> show 404 wurde irgendwo aufgerufen"
    render :file => 'public/404.html', :status => 404
  end

end
