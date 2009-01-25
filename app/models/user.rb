class User < ActiveRecord::Base
  belongs_to :role
  has_one :userdata, :dependent => :destroy
  
  validates_presence_of :user_name, :message => "darf nicht leer sein!"
  validates_presence_of :password
  validates_uniqueness_of :user_name, :message => "ist schon vergeben!"
  validates_length_of :user_name, :in => 6..20
  validates_confirmation_of :password
  validates_length_of :password, :in => 8..20
#  validates_format_of :password, :with => /(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,15})$/,
#                      :message => "entspricht nicht den Passwortregeln!"
  validates_format_of :password, :with => /(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/,
                      :message => "entspricht nicht den Passwortregeln!"

  attr_reader :password
  

  def password=(pw)
    @password = pw # used by confirmation validator
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp # 2^48 combos
    self.password_salt, self.password_hash =
      salt, Digest::MD5.hexdigest(pw + salt)
  end

  def password_is?(pw)
    Digest::MD5.hexdigest(pw + password_salt) == password_hash
  end
  
  def last_passwords_differ_from?(pw)
    return true if Digest::MD5.hexdigest(pw + password_salt) != password_hash and
      Digest::MD5.hexdigest(pw + self.userdata.password1_salt) != self.userdata.password1_hash and
      Digest::MD5.hexdigest(pw + self.userdata.password2_salt) != self.userdata.password2_hash and
      Digest::MD5.hexdigest(pw + self.userdata.password3_salt) != self.userdata.password3_hash
  end
  
  def has_permission?(controller, action)
    p = Permission.find(:first, :conditions =>
      ["role_id = ? and controller_name = ? and action_name = ?", self.role_id, controller, action])

    if p and p.permission == 'allow'
      return true
    else
      return false
    end
  end
  
  def is_admin?
    r = Role.find_by_role_name('Administrator')
    return self.role_id == r.id
  end
  
  def get_salt(pass)
    return [Array.new(6){rand(256).chr}.join].pack("m").chomp
  end
  
  def get_hash(pass, salt)
    return Digest::MD5.hexdigest(pass + salt)
  end
  
  def activate(reason)
    self.userdata.update_attribute(:deactivated, false)
    self.userdata.update_attribute(:deactivation_reason, reason)
    self.userdata.update_attribute(:password_faults, 0)
    ll = Time.now.gmtime
    ll -= @settings["deactivate_after_inactive_days"].to_i.days if self.userdata.deactivate_inactive_users
    self.userdata.update_attribute(:last_login, ll)
  end
  
  def deactivate(reason)
    self.userdata.update_attribute(:deactivated, true)
    self.userdata.update_attribute(:deactivation_reason, reason)
    self.userdata.update_attribute(:deactivation_date, Time.now.gmtime)  
  end
  
  def activate(reason)
    self.userdata.update_attribute(:deactivated, false)
    self.userdata.update_attribute(:deactivation_reason, reason)
    self.userdata.update_attribute(:deactivation_date, Time.now.gmtime)  
  end
  
  def is_admin?
    return self.role.role_name == "Administrator"
  end
  
  def active?
    return !self.userdata.deactivated
  end
    
  def after_create
    ud = Userdata.new
    ud.user_id = self.id
    ud.last_login = Time.now.gmtime
    ud.deactivated = 1
    ud.save
  end

end
