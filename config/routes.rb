Geengo::Application.routes.draw do

  devise_for :users
  devise_for :employees, :controllers => {
    :registrations => "employees/registrations",
    :confirmations => "employees/confirmations"
  }

  get "/first_connection", :to => "first_connections#edit"
  put "/first_connection", :to => "first_connections#update"

  devise_scope :employee do
    get "/activation_pending", :to => "employees/registrations#activation_pending"
  end

  match "/firms/:id.css", :to => "firms#show", :format => "css"

  resources :administrative_documents, :only => [:create, :update, :destroy]
  resource :profile, :only => [:show, :update] do
    %w(perso password sports documents).each do |action|
      get "/#{action}", :action => action
    end
  end

  resources :messages, :only => [:create]

  match "/employees/valid_email", :to => "employees#valid_email"

  # custom rails_admin routes
  scope "/admin" do
    get "/employees"                  , :to => "rails_admin/employees#list"         , :model_name => "employees"
    post "/employees/bulk_action"     , :to => "rails_admin/employees#bulk_action"  , :model_name => "employees"
    get "/employees/:id/edit"         , :controller => "rails_admin/employees"      , :action => "edit"          , :model_name => "employees", :as => "edit_employee"
    put "/admins/:id"                 , :controller => "rails_admin/admins"         , :action => "update"        , :model_name => "admins"

    post "/:model_name"               , :controller => "rails_admin/imports"        , :action => "create"        , :constraints => {:model_name => /employees_imports|infrastructures_imports|events_imports/}
    get "/imports/:import_id/discards", :controller => "rails_admin/import_discards", :action => "list"          , :model_name => "import_discards"

    get "/user/:id/edit"              , :controller => "rails_admin/users"          , :action => "edit"          , :model_name => "user"
    put "/users/:id"                  , :controller => "rails_admin/users"          , :action => "update"        , :model_name => "users"
    get "/infrastructures/:id/edit"   , :controller => "rails_admin/infrastructures", :action => "edit"          , :model_name => "infrastructures"
    put "/infrastructures/:id"        , :controller => "rails_admin/infrastructures", :action => "update"        , :model_name => "infrastructures"

    mount Resque::Server, :at => "/resque"
    mount RailsAdmin::Engine => '/', :as => 'rails_admin'
  end

  match "/events", :to => "events#index", :as => "all_events"

  resources :sport_community_memberships, :only => [:create, :update, :destroy]

  scope "/:sport_name" do
    match "/community", :controller => "sport_communities", :action => "show", :as => :sport_community
    match "/community/members", :to => "members#index", :as => "community_members"
    resources :infrastructures, :only => [:index, :show]
    resources :events, :only => [:index, :show]
    match "/:parent_type/:parent_id/members", :to => "members#index"
    root :to => redirect("/%{sport_name}/community")
  end

  root :to => 'profiles#show'

end
