class Setting < ActiveRecord::Base
  
  validates_presence_of :key
  validates_presence_of :value
  validates_uniqueness_of :key
  #Format für key, value
   
  def self.get_settings
    settings = self.find(:all)
    s_hash = Hash.new
    settings.each do |s|
      # im Moment ist default_page der einzige "echte" String, der Rest ist Integer
      # Muss ggf. angepasst werden, wenn weitere Strings dazu kommen
      if s.key == "default_page" then
        s_hash[s.key] = s.value
      else
        s_hash[s.key] = s.value.to_i
      end
    end
    return s_hash
  end
  
end
