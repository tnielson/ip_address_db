module UsersHelper
   
  # Liefert true, falls aktueller user admin ist, sonst false
  # Muss spaeter implementiert werden, wenn groups verf�gbar sind
  def self.admin?
    true
  end
  
  # True, wenn User eingeloggt ist
  def logged_in?
    session[:uid]
  end
  
  # Setzt die Klasse f�r Men�eintr�ge
  def active_page(name_a, name_b)
    if name_a == name_b
      return 'active'
    else
      return 'inactive'
    end
  end

end
