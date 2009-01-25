class Permission < ActiveRecord::Base
  # Wird an role gehaengt. Jede Rolle hat individuelle Berechtigungen des Zugriffs
  belongs_to :role
  
  # Findet alle Actions eines Controllers und ordnet sie den verschiedenen Rollen
  # zu. Dabei wird der Rolle Administrator alles erlaubt, allen anderen Rollen
  # grundsaetzlich alles verboten. Ausnahmen: welcome und login des Users-Contoller
  # Bestehende Berechtigungen werden nicht ueberschrieben. Loeschungen von actions
  # werden bemerkt.
  def self.set_new_permissions
    allow_users = %w{ welcome login logout show change_password my_settings update_my_settings}
    @roles = Role.find(:all)
    @controllers = Hash.new
    c = Dir.new("#{RAILS_ROOT}/app/controllers").entries
    c.each do |controller|
      if controller =~ /_controller/
        cont = controller.camelize.gsub(".rb","")
        actions = eval("#{cont}.instance_methods(false)")
        @controllers[cont] = actions
      end
    end
    # Rollen und actions mit Permissions versehen, sofern sie noch nicht bestehen
    @roles.each do |role|
      @controllers.each do |controller, actions|
        actions.each do |action|
          # Wenn die Permission noch nicht existiert, neu anlegen
          unless Permission.find_by_role_id_and_controller_name_and_action_name(role.id, controller, action)
            p = Permission.new
            p.role_id = role.id
            p.controller_name = controller
            p.action_name = action
            if role.role_name == 'Administrator'
              p.permission = 'allow'
            else
              if controller == 'UsersController'and allow_users.include?(action)
                p.permission = 'allow'
              end
            end #else
            # deny muss nicht definiert werden. Ist Default des Feldes in der Datenbank
            p.save
          end #unless; wenn die action gefunden wurde, bleiben die bisherigen Werte erhalten.
        end #actions.each
      end #@controllers.each
    end #@roles.each
    # Permissions loeschen, die auf actions zeigen, die nicht mehr exisitieren.
    # Wird nur in der Entwicklungsphase benoetigt.
    @controllers.each do |c, a|
      # Finde alle actions, die in einem Controller definiert sind
      real_actions = a
      # Finde alle actions, die in Permissions definiert sind
      permissions = Permission.find_all_by_controller_name(c)
      perm_actions = Array.new
      permissions.each do |p|
        perm_actions << p.action_name
      end
      perm_actions.uniq!
      # Ermittle, welche actions geloescht werden muessen
      del_actions = perm_actions - real_actions
      # Ermittle, welche Permissions geloescht werden muessen
      unless del_actions.empty? then
        del_actions.each do |action|
          del_perm = Permission.find_all_by_controller_name_and_action_name(c, action)
          del_perm.each do |dp|
            dp.destroy
          end
        end
      end
      # 
    end
  end #self.set_new_permissions
  
  def before_save
    self.permission = 'deny' if self.permission != 'allow'
  end
  
end
