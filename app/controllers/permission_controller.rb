class PermissionController < ApplicationController
  layout "ipnets"
  
  def list
    @role = Role.find(params[:id], :include => "permissions", :order => "role_name, permissions.controller_name, permissions.action_name")
  end

  def list_all
    @roles = Role.find(:all, :include => "permissions", :order => "role_name, permissions.controller_name, permissions.action_name")
  end
  
  def import_actions
    Permission.set_new_permissions
    redirect_to(:action => 'list_all')
  end
  
  def toggle_permission
    permissions = Array.new
    ok = true
    begin
      if params[:select]
        permissions = Permission.find(params[:select])
      else
        permissions[0] = Permission.find(params[:id])
      end
      permissions.each do |p|
        if p.permission == 'allow'
          p.permission = 'deny'
        else
          p.permission = 'allow'
        end
        ok = false unless p.save
      end
      if ok
        flash[:notice] = "Berechtigung(en) aktualisiert!"
      else
        flash[:error] = "Eine oder mehrere &Auml;nderungen konnte nicht gespeichert werden"
      end
      redirect_to(:action => 'list', :id => permissions[0].role_id)
    rescue
      flash[:error] = "Sie m&uuml;ssen mind. einen Eintrag ausw&auml;hlen!"
      redirect_to(:controller => 'roles', :action => 'index')
    end
  end
  
end
