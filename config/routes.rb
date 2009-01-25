ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  Translate::Routes.translation_ui(map) if RAILS_ENV != "production"

  map.connect 'ipnets/packzusammen', :controller => 'ipnets', :action => 'packzusammen'
  map.connect 'ipnets/new_ipnet', :controller => 'ipnets', :action => 'new_ipnet'
  #map.connect 'containers/new_container', :controller => 'ipnets', :action => 'new_ipnet'



  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  map.connect 'users/login', :controller => 'users', :action => 'login'
  map.connect 'users/logout', :controller => 'users', :action => 'logout'
  map.connect 'users/welcome', :controller => 'users', :action => 'welcome'
  map.connect 'users/new_user', :controller => 'users', :action => 'new_user'
  map.connect 'users/change_password', :controller => 'users', :action => 'change_password'
  map.connect 'users/update_password', :controller => 'users', :action => 'update_password'
  map.connect 'users/my_settings', :controller => 'users', :action => 'my_settings'
  map.connect 'users/update_my_settings', :controller => 'users', :action => 'update_my_settings'
  map.connect 'users/administrate_users', :controller => 'users', :action => 'administrate_users'
  map.connect 'users/recover_password', :controller => 'users', :action => 'recover_password'
  map.connect 'types/destroy_habtm_relation', :controller => 'types', :action => 'destroy_habtm_relation'
  map.connect 'settings/edit', :controller => 'settings', :action => 'edit'

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  map.resources :users
  map.resources :roles
  map.resources :ipnets
  map.resources :ipnets, :collection => { :packzusammen => :get }
  map.resources :settings
  map.resources :containers
  map.resources :types
  map.resources :keys

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
