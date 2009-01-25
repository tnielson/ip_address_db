class RolesController < ApplicationController
  layout "ipnets"
  
  # GET /roles
  def index
    @roles = Role.find(:all, :order => 'role_name')
    
    respond_to do |format|
      format.html
    end
  end
  
  # GET /roles/new
  def new
    @role = Role.new
    
    respond_to do |format|
      format.html
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  # POST /roles
  def create
    @role = Role.new(params[:role])
    
    respond_to do |format|
      if @role.save
        flash[:notice] = "Neue Rolle #{@role.role_name} wurde angelegt!"
        format.html { redirect_to(@role) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  # GET /roles/1
  def show
    @role = Role.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  # PUT /roles/1  
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = "Rolle #{@role.role_name} wurde aktualisiert."
        format.html { redirect_to(@role) }
      else
        format.html { render :action => "edit" }
      end
    end  
  end
  
  # DELETE /roles/1
  def destroy
    @role = Role.find(params[:id])
    name = @role.role_name
    
    respond_to do |format|
      begin
        Role.transaction do
          @role.destroy
        end
        flash[:notice] = "Rolle #{name} wurde gel&ouml;scht!"
        format.html { redirect_to(roles_url) }
      rescue => exception
        flash[:error] = exception.message
        format.html { redirect_to(roles_url) }
      end
    end  
  end
  
end
