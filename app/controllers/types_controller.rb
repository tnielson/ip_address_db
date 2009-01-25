class TypesController < ApplicationController
  layout "ipnets"
    
  def index 
    @types= Type.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @types }
    end
  end
  
  def show
    @type = Type.find(params[:id])
    @keys = @type.keys
  end

  def new
    @type = Type.new
    
     respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @type }
    end
  end
  
  def create
    @type = Type.new(params[:type])
    
    respond_to do |format|
        if @type.save
          flash[:notice] = 'Type wurde erfolgreich erstellt. Bitte fügen Sie nun Schlüssel hinzu.'
          format.html { redirect_to(:action => "edit", :id => @type.id ) } 
          format.xml  { render :xml => @type, :status => :created, :location => @type }
        else
          format.html { render :action => "new"}
           format.xml  { render :xml => @type.errors, :status => :unprocessable_entity }
        end #if
     end #respond
  end #def
  
  def edit
    @type = Type.find(params[:id])
    @keys = @type.keys
    @keyselection = Key.find(:all)
    
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @type }
    end
  end  
  
  def update
    @type = Type.find(params[:id])
    neues_ele = nil
    params.each do |k,v|
     puts "params: k - #{k} , v - #{v}"
    end
    
    params.each do |k,v| #Durchlaufe jedes Key-Value-Pärchen von Params
      if (k == "key")
        v.each do |a,b|
           puts "in b steht: #{b}"
           neues_ele = Key.find_by_key_name(b) if b != ""
           puts "neues ELE: #{neues_ele}"
        end
      end
    end
    
    respond_to do |format|
      if neues_ele
        @type.keys << neues_ele unless @type.keys.include?(neues_ele)
        @type.save
        puts "TYPE GESPEICHERT"
        flash[:notice] = 'Type wurde erfolgreich geändert'
        format.html { redirect_to(:action => "edit", :id => @type.id) }
        format.xml  { head :ok }
      else
        if @type.update_attributes(params[:type])   
        flash[:notice] = 'Type wurde erfolgreich geändert'
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit"}
        format.xml  { render :xml => @type.errors, :status => :unprocessable_entity }
      end
      end

    end
  end
  
  def destroy
    @type = Type.find(params[:id])
    @type.destroy
    respond_to do |format|
      flash[:notice] = 'Type wurde erfolgreich gelöscht'
      format.html { redirect_to(:action => "index") } 
      format.xml  { head :ok }
    end
  end
 
  def destroy_habtm_relation
    puts "----------------- TYPES CONTROLLER --- delete_habtm_relation"
    @type = Type.find(params[:type_id])
    key = Key.find(params[:key_id])
    
    respond_to do |format|
      if key
        @type.keys.delete(key)
        flash[:notice] = 'Key wurde erfolgreich entfernt'
      else 
        flash[:error] = 'Key-Datensatz wurde nicht gefunden und konnte nicht gelöscht werden'
      end
      format.html { redirect_to(:action => "edit", :id => @type.id) }
      format.xml  { head :ok }
    end
  end    

end