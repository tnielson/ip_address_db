class KeysController < ApplicationController
  layout "ipnets"
  
  def index 
    @keys = Key.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @keys }
    end
  end

  def new
    @key = Key.new
    
     respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @key }
    end
  end
  
  def create
    @key = Key.new(params[:key])
    
    respond_to do |format|
        if @key.save
          flash[:notice] = 'Key wurde erfolgreich erstellt.'
          format.html { redirect_to(:action => "index") } 
          format.xml  { render :xml => @key, :status => :created, :location => @key }
        else
          format.html { render :action => "new"}
           format.xml  { render :xml => @key.errors, :status => :unprocessable_entity }
        end #if
     end #respond
  end #def
  
  def edit
    @key = Key.find(params[:id]) 
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @key }
    end
  end  
  
  def update
    @key = Key.find(params[:id])
    
    respond_to do |format|
      if @key.update_attributes(params[:key])
        flash[:notice] = 'Schlüssel wurde erfolgreich geändert'
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit"}
        format.xml  { render :xml => @key.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @key = Key.find(params[:id])
    @key.destroy
    respond_to do |format|
      if Attri.find_by_key_id(@key)
        flash[:error] = 'Schlüssel ist noch in Verwendung'
      else
        flash[:notice] = 'Schlüssel wurde erfolgreich gelöscht'
        format.html { redirect_to(:action => "index") } 
        format.xml  { head :ok } 
      end
    end
  end
     
end #class