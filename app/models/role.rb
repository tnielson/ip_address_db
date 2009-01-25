class Role < ActiveRecord::Base
  has_many :users
  has_many :permissions, :dependent => :destroy
  
  validates_uniqueness_of :role_name
  
  # Verhindert, dass der role_name "Administrator" oder "Gast" umbenannt wird
  def before_update
    r = Role.find(self.id)
    if r.role_name == 'Administrator' then
      if r.role_name != self.role_name then
        errors.add(:role_name, "Administrator darf nicht umbenannt werden")
        self.role_name = r.role_name
      end
    end
    if r.role_name == 'Gast' then
      if r.role_name != self.role_name then
        errors.add(:role_name, "Gast darf nicht umbenannt werden")
        self.role_name = r.role_name
      end
    end    
  end
  
  def before_destroy
    # Test, ob eine der Rollen 'Administrator' oder 'Gast' geloescht werden soll
    str = self.role_name
    raise "Rolle #{str} darf nicht geloescht werden!" if (str == 'Administrator') or (str == 'Gast')
    # Test, ob noch User an dieser Rolle haengen
    users = User.find_by_role_id(self.id)
    raise "Rolle #{str} enthaelt noch Nutzer!" if users
  end
  
  def after_create
    Permission.set_new_permissions
  end
  
end
