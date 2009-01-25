class ContainersController < ApplicationController
  layout "ipnets"
  
  def index
    
    if Type.count == 0
      redirect_to :controller => 'types', :action => 'new'
      flash[:notice] = 'Bitte legen Sie zunächst einen neuen Typen an.'
    else
      
      if not params[:current_object]
        @net = Container.find(:first, :conditions => "name = 'root'") 
      else
        @net = Container.find(params[:current_object]) #Sonst aktueller Container
      end    
      session[:current_object] = @net.id
      
      puts "ergebnis: container = #{session[:current_object]}"
      @containers = Container.find(:all)
      #@containers = Container.paginate  :per_page => 4, :page => params[:page],
                                      #:conditions => ["parent_id = ?", session[:current_container]],
                                      #:order => 'id'
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @containers }
      end #respond
  
    end #if
  end #def
  
  def show
    @container = Container.find(params[:id])
    @attris = @container.attris
  end

  def new
    type = nil;
    
    params[:type].each do |k,v|  
      @type = Type.find_by_name(v) if v.length > 4
      puts "------------ type gefunden? #{type}"
    end
    @keys = @type.keys
    puts "----------- keys: #{@keys}"
    @container = Container.new
     respond_to do |format|
       puts "rendere container.new.html"
      format.html # new.html.erb
      format.xml  { render :xml => @container }
      
    end
  end
  
  def create
    puts "anfang der container.create action controller"
    puts "params[:container] : #{params[:container][:type_id].to_i}"
    @container = Container.new(params[:container])
    # sollte noch eleganter zu lösen sein -> horst fragen
    attr_hash = Hash.new
    params.each do |k,v|
      attr_key = nil
      attr_value = nil
      if k.to_i > 0
        puts "#{k} umgewandelt #{k.to_i} ist ne zahl: #{k}"
        puts "und der wert ist: #{v}"
        v.each do |a,b|
          puts "a - #{a}"
          puts "b - #{b}"
          a == "value" ?  attr_value = b: attr_key = b
        end
      end
      puts "bevor werte reingepackt werden: key - #{attr_key} value - #{attr_value} key= nil? #{attr_key.nil?}"
      attr_hash[attr_key] = attr_value if (!attr_key.nil? and !attr_value.nil?) #erstellt ein neues key-value pärchen im hash
    end #each 
      puts "Hash wurde erstellt. Werte?"
      puts "hier der hash #{attr_hash}"
      puts "leer? #{attr_hash.empty?} und groeße? #{attr_hash.size}"
    
    respond_to do |format|
        if @container.save
          attr_hash.each do |k,v|
          puts "---------- erstelle attr!!"
            @container.attris.create(:container_id => @container.id, :key_id => k, :value => v)
          end
          flash[:notice] = 'Container wurde erfolgreich erstellt.'
          format.html { redirect_to(:action => "index") } 
          format.xml  { render :xml => @container, :status => :created, :location => @key }
        else
          format.html { render :action => "new"}
          format.xml  { render :xml => @container.errors, :status => :unprocessable_entity }
        end #if      
    end #respond
  end #def
  
  def edit
    @container= Container.find(params[:id])
    
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @container }
    end
  end  
  
  def update
    respond_to do |format|
      if @container.update_attributes(params[:ipnet])
        flash[:notice] = 'Container wurde erfolgreich geändert'
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit"}
        format.xml  { render :xml => @container.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @container = Container.find(params[:id])
    @container.destroy
    respond_to do |format|
      flash[:notice] = 'Container wurde erfolgreich gelöscht'
      format.html { redirect_to(:action => "index") } 
      format.xml  { head :ok }
    end
  end
  
end
