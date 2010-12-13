ActionController::Routing::Routes.draw do |map|

  map.root :controller => "tickets", :action => "index"

  map.resources :contacts

  map.resources :admin, :collection => [:forgot_password, :delivery_password, :login, :logout, :acesso_negado]

  map.resources :groups

  map.resources :users

  map.resources :languages

  map.resources :log_works

  map.resources :ticket_files

  map.resources :comments

  map.resources :comments_files

  map.resources :enterprises

  map.resources :tickets

  map.resources :global_configurations

  map.connect 'tickets/auto_complete/field/:field/language/:language', :controller => :tickets, :action => :auto_complete

  map.connect 'tickets/print/:id', :controller => :tickets, :action => :print

  
  #map.connect '/contents/:id/language/:language_id', :controller => 'contents', :action => 'edit'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

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
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
