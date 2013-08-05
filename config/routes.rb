HanaMech::Application.routes.draw do
  get "login", to: 'sessions#new', as: 'login'
  post "login", to: "sessions#create", as: 'process_login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  resources :main, :workorders

  resources :customers do
    resources :cars
    resources :users, only: [:new]
  end

  resources :cars do
    resources :workorders
  end

  resources :workorders do
    get "printable/:id", :to => "workorders#printable"
  end

  resources :users, except: [:new]

  root to: "main#index"
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

=begin
             login GET    /login(.:format)                                  sessions#new
     process_login POST   /login(.:format)                                  sessions#create
            logout GET    /logout(.:format)                                 sessions#destroy
        main_index GET    /main(.:format)                                   main#index
                   POST   /main(.:format)                                   main#create
          new_main GET    /main/new(.:format)                               main#new
         edit_main GET    /main/:id/edit(.:format)                          main#edit
              main GET    /main/:id(.:format)                               main#show
                   PATCH  /main/:id(.:format)                               main#update
                   PUT    /main/:id(.:format)                               main#update
                   DELETE /main/:id(.:format)                               main#destroy
        workorders GET    /workorders(.:format)                             workorders#index
                   POST   /workorders(.:format)                             workorders#create
     new_workorder GET    /workorders/new(.:format)                         workorders#new
    edit_workorder GET    /workorders/:id/edit(.:format)                    workorders#edit
         workorder GET    /workorders/:id(.:format)                         workorders#show
                   PATCH  /workorders/:id(.:format)                         workorders#update
                   PUT    /workorders/:id(.:format)                         workorders#update
                   DELETE /workorders/:id(.:format)                         workorders#destroy
     customer_cars GET    /customers/:customer_id/cars(.:format)            cars#index
                   POST   /customers/:customer_id/cars(.:format)            cars#create
  new_customer_car GET    /customers/:customer_id/cars/new(.:format)        cars#new
 edit_customer_car GET    /customers/:customer_id/cars/:id/edit(.:format)   cars#edit
      customer_car GET    /customers/:customer_id/cars/:id(.:format)        cars#show
                   PATCH  /customers/:customer_id/cars/:id(.:format)        cars#update
                   PUT    /customers/:customer_id/cars/:id(.:format)        cars#update
                   DELETE /customers/:customer_id/cars/:id(.:format)        cars#destroy
    customer_users POST   /customers/:customer_id/users(.:format)           users#create
 new_customer_user GET    /customers/:customer_id/users/new(.:format)       users#new
         customers GET    /customers(.:format)                              customers#index
                   POST   /customers(.:format)                              customers#create
      new_customer GET    /customers/new(.:format)                          customers#new
     edit_customer GET    /customers/:id/edit(.:format)                     customers#edit
          customer GET    /customers/:id(.:format)                          customers#show
                   PATCH  /customers/:id(.:format)                          customers#update
                   PUT    /customers/:id(.:format)                          customers#update
                   DELETE /customers/:id(.:format)                          customers#destroy
    car_workorders GET    /cars/:car_id/workorders(.:format)                workorders#index
                   POST   /cars/:car_id/workorders(.:format)                workorders#create
 new_car_workorder GET    /cars/:car_id/workorders/new(.:format)            workorders#new
edit_car_workorder GET    /cars/:car_id/workorders/:id/edit(.:format)       workorders#edit
     car_workorder GET    /cars/:car_id/workorders/:id(.:format)            workorders#show
                   PATCH  /cars/:car_id/workorders/:id(.:format)            workorders#update
                   PUT    /cars/:car_id/workorders/:id(.:format)            workorders#update
                   DELETE /cars/:car_id/workorders/:id(.:format)            workorders#destroy
              cars GET    /cars(.:format)                                   cars#index
                   POST   /cars(.:format)                                   cars#create
           new_car GET    /cars/new(.:format)                               cars#new
          edit_car GET    /cars/:id/edit(.:format)                          cars#edit
               car GET    /cars/:id(.:format)                               cars#show
                   PATCH  /cars/:id(.:format)                               cars#update
                   PUT    /cars/:id(.:format)                               cars#update
                   DELETE /cars/:id(.:format)                               cars#destroy
                   GET    /workorders/:workorder_id/printable/:id(.:format) workorders#printable
                   GET    /workorders(.:format)                             workorders#index
                   POST   /workorders(.:format)                             workorders#create
                   GET    /workorders/new(.:format)                         workorders#new
                   GET    /workorders/:id/edit(.:format)                    workorders#edit
                   GET    /workorders/:id(.:format)                         workorders#show
                   PATCH  /workorders/:id(.:format)                         workorders#update
                   PUT    /workorders/:id(.:format)                         workorders#update
                   DELETE /workorders/:id(.:format)                         workorders#destroy
             users GET    /users(.:format)                                  users#index
         edit_user GET    /users/:id/edit(.:format)                         users#edit
              user PATCH  /users/:id(.:format)                              users#update
                   PUT    /users/:id(.:format)                              users#update
                   DELETE /users/:id(.:format)                              users#destroy
              root GET    /                                                 main#index                                                      main#index                                                 main#index
=end
end
