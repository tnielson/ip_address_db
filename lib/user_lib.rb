module UserLib

  def filter(controller)
    # Aufrufenden User identifizieren oder Gast-User erzeugen
    if session[:uid] then
      @user = User.find(session[:uid])
    else
      @user = User.new
      @user.username = "Gast"
    end  
  end

end
