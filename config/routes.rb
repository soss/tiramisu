Tiramisu::Application.routes.draw do

  #get "password_resets/create"
  #get "password_resets/edit"
  #get "password_resets/update"

  get 'logout'  => 'sessions#destroy', :as => 'logout'
  get 'login'   => 'sessions#new', :as => 'login'
  get 'signup'  => 'users#new', :as => 'signup'
  
  resources :users
  resources :sessions
  resources :password_resets
  resources :projects do
    post 'comments' => 'comments#create', :as => 'comments'
    get  'comments/:id/edit' => 'comments#edit', :as => 'edit_comment'
    put  'comments/:id' => 'comments#update', :as => 'comment'
    delete 'comments/:id' => 'comments#destroy'
  end

  post '/projects/:id/promote' => 'projects#promote', :as => 'promote_project'
  post '/projects/:id/pledge'  => 'projects#pledge', :as => 'pledge_project'
  post '/projects/:id/leave'   => 'projects#leave', :as => 'leave_project'

  get '/moderate' => 'projects#moderate', :as => 'moderate'
  post '/projects/:id/approve' => 'projects#approve', :as => 'approve_project'

  get '/:username/projects' => 'users#projects', :as => 'user_projects'
  get '/settings' => 'users#edit', :as => 'user_settings'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.
  root :to => 'projects#index'

  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
