Dynamic::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "user/omniauth_callbacks" }

  resources :projects do
    member do
      post 'request_membership', :as => 'request_membership_project'
      put 'invite_member', :as => 'invite_member_project'
    end
    collection do
      get 'home', :as => 'home_projects'
    end
    scope '/memberships' do
      put ':membership_id/accept_invitation' => 'project/memberships#accept_invitation', :as => :accept_invitation_project_membership
      put ':membership_id/accept_member' => 'project/memberships#accept_member', :as => :accept_member_project_membership
    end
  end

  resources :users do
    collection do
      get 'users/home' => 'users#home', :as => 'home_users'
    end
  end

  namespace :user do
    resources :profiles
    resources :networks
  end

  resource :activations

  get "static/home"
  get "static/news"
  get "static/about"

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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => "static#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
