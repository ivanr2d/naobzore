class CategoryConstraints
  def self.matches? request
    !Category.find_by_alias(request.path_parameters[:category]).nil?
  end
end

class PageLinkConstraints
  def self.matches? request
    !Page.find_by_link(request.path_parameters[:link]).nil?
  end
end

class CompanySubdomainConstraints
  def self.matches? request
    !!(m = request.server_name.match(/^([\w\d\-]+)\.naobzore/) and (Site.find_by_subdomen(m[1]).try(:company) || Subdomain.find_by_name(m[1]).try(:company)))
  end
end

OnshowLoc::Application.routes.draw do
  # XXX in rails 4 use concerns
  def likes
    post :like
    post :ignore
    post :favorite
  end

  # minisite
  scope :module => "minisite" do
    constraints CompanySubdomainConstraints do
      root :to => 'home#index'
      resources :goods, :only => [:index, :show] do
        member do
          likes
        end
      end
      resources :services, :only => [:index, :show] do
        member do
          likes
        end
      end
      resources :users, :only => [] do
        member do
          put :subscribe
        end
      end
      resources :news, :only => [] do
        resources :comments, :only => [:index, :create]
        member do
          likes
        end
      end
      get '/news' => 'news#index'
      get '/news/:id' => 'news#show'
      resources :campaigns, :only => [:index, :show] do
        member do
          post :campaign_send
          likes
        end
        resources :comments, :only => [:index, :create]
      end
      get '/about' => 'home#about', :as => :about
      get '/contacts' => 'home#contacts', :as => :contacts
      get '/search' => 'home#search', :as => :search
      resources :jobs, :only => [:index, :show] do
        resources :comments, :only => [:index, :create]
        member do
          likes
        end
      end
      resources :resumes, :only => [] do
        member do
          post :resume_send
        end
      end
      resources :feedbacks, :only => [] do
        member do
          likes
        end
      end
      resources :messages, :only => :create
    end
  end # minisite

  # main site
  mount Ckeditor::Engine => '/ckeditor'

  match "favorite/:type/:id/:status" => "favorites#plus"
  get "like/:type/:id" => "likes#add"
  
  get "/cabinet/ajax/:id/:type" => "cabinet#ajax"
  get "/cabinet/switching/:id/:type/:direction/:type_one" => "cabinet#switching"
  get "cabinet/:type" => "cabinet#entities"

  #Страницы сущностей (Запросы для попапа)
  get "/goods/ajax/:id/:type" => "goods#ajax"
  get "/goods/switching/:id/:direction/" => "goods#switching"
  get "/goods/switching/:category/:id/:direction/" => "goods#switching"
  
  get "/services/ajax/:id/:type" => "services#ajax"
  get "/services/switching/:id/:direction/" => "services#switching"
  get "/services/switching/:category/:id/:direction/" => "services#switching"
  
  get "/jobs/ajax/:id/:type" => "jobs#ajax"
  get "/jobs/switching/:id/:direction/" => "jobs#switching"
  get "/jobs/switching/:category/:id/:direction/" => "jobs#switching"
  
  get "/companies/ajax/:id/:type" => "companies#ajax"
  get "/companies/switching/:id/:direction/" => "companies#switching"
  get "/companies/switching/:category/:id/:direction/" => "companies#switching"
  
  get "/campaigns/ajax/:id/:type" => "campaigns#ajax"
  get "/campaigns/switching/:id/:direction/" => "campaigns#switching"
  get "/campaigns/switching/:category/:id/:direction/" => "campaigns#switching"

  #devise_for :users
  devise_for :users do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end

  ActiveAdmin.routes(self)
  
  default_url_options :host => "naobzore.ru"

  #devise_for :admin_users, ActiveAdmin::Devise.config

  resources :cabinet

  resources :products

  #resources :users


  resources :pages


  resources :banners


  resources :sites
  
  #help
  get "help" => "help#index"
  get "help/:category" => "help#index"
  get "help/:alias" => "help#index"
  get "help/show/:alias" => "help#show"
  
  #Feedbacks
  get "/feedbacks" => "feedbacks#index"
  get "/feedbacks/:category" => "feedbacks#index"
  post "/feedbacks/add" => "feedbacks#add"
  
  #resources :campaigns
  get "campaigns/" => "campaigns#index"
  get "campaigns/:category" => "campaigns#index", :constraints => CategoryConstraints
  get "campaigns/:id" => "campaigns#show", :as => :campaign
  get "campaigns/:category/:id" => "campaigns#show"
  
  #news
  get "news/" => "news#index"
  get "news/:category" => "news#index", :constraints => CategoryConstraints
  get "news/:id" => "news#show", :as => 'show_news'
  get "news/:category/:id" => "news#show"

  #resources :companies
  get "/companies" => "companies#index"
  get "/companies/:category" => "companies#index"

  #resources :jobs
  get "/jobs" => "jobs#index"
  get "/jobs/:category" => "jobs#index", :constraints => CategoryConstraints
  get "/jobs/:id" => "jobs#show", :as => :job
  get "/jobs/:category/:id" => "jobs#show"
  
  #resources :resume
  get "/resume" => "resume#index"
  get "/resume/:category" => "resume#index", :constraints => CategoryConstraints
  get "/resume/:id" => "resume#show"
  get "/resume/:category/:id" => "resume#show"

  #resources :services
  get "/services" => "services#index"
  get "/services/:category" => "services#index", :constraints => CategoryConstraints
  get "/services/:id" => "services#show", :as => :service
  get "/services/:category/:id" => "services#show"

  #resources :goods
  get "/goods" => "goods#index"
  get "/goods/:category" => "goods#index", :constraints => CategoryConstraints
  get "/goods/:id" => "goods#show", :as => :good
  get "/goods/:category/:id" => "goods#show"

  resources :categories

  match '/social/export' => 'social#export', :as => :social_export
  # main site end

  namespace :company_panel do
    root :to => 'home#index'

    post '/widgets/save_order' => 'home#save_widgets_order'
    get '/mail' => 'home#mail'
    get '/site_control' => 'home#site_control'
	
	#TODO edit route
	get '/messages/dialog' => 'messages#dialog'

    resources :statistics, :only => [:index]
    resources :news, :only => [:new, :create]
    resources :users, :only => [:edit, :update, :destroy] do
      member do
        get :edit_password
        put :update_password
        get :edit_email
        put :update_email
        get :delete_account
      end
      collection do
        get :search
      end
    end
		resources :messages, :only => [:index, :create]
		resources :resumes, :only => [:index, :show, :destroy] do
			member do
				post :offer
			end
      collection do
        get :search
      end
		end
    resources :subscribes, :only => [:index, :destroy]
    resources :emails, :only => [:index]
    resources :sms, :only => [:index]
    resources :calls, :only => [:index]
    %w(goods services campaigns jobs).each do |r|
      resources r.to_sym, :only => [:index, :new, :create, :edit, :update] do
        collection do
          post :mass_publish
          post :mass_unpublish
          post :mass_destroy
          get :search
        end
        member do
          post :mass_set_photos
          get :load_image
        end
      end
    end
    get '/campaigns/entities' => 'campaigns#entities', :as => 'campaigns_entities'
    resources :price_lists, :only => [:new, :create]
    resources :price_entities, :only => [:index, :update] do
      collection do
        post :mass_destroy
        post :export
      end
      member do
        post :mass_set_photos
        get :load_image
      end
    end
    get '/pages/:link' => 'pages#show', :constraints => PageLinkConstraints, :as => :page
    resources :categories, :only => [:index]
    resources :photos, :only => [:index, :create, :update, :destroy] do
      collection do
        post :mass_destroy
        get :entities
      end
    end
    resources :packages, :only => [] do
      collection do
        get :placing
        get :communication
      end
    end
    resources :companies_packages, :only => [:create] do
      member do
        post :set_auto
      end
    end
    resources :banners, :only => [:new, :create]
    resources :companies, :only => [:edit, :update] do
      member do
        get :legal
        get :logotype
        get :tmp_logotype
        get :schedule
        get :crediting
      end
    end
    resources :banks
    resources :companies_users, :only => [:index, :create, :destroy] do
      collection do
        get :search
        get :user_by_email
        put :user_phone_email
        post :invite
      end
    end
    resources :deliveties, :warranties
    resources :menus, :only => [:index] do
      collection do
        post :set_order
      end
    end
    resources :subdomains, :only => [:index] do
      collection do
        post :mass_save
      end
    end
    resources :sites, :only => [:update] do
      member do
        get :stats
        get :webmaster
        get :sitemap
        get :robots
        get :construct
        put :commit
      end
    end
    resources :invoices do
      member do
        put :pay
      end
      collection do
        get :movement
      end
    end
    resources :factures
    resources :acts
    resources :tutorials, :only => [:index]
    resources :feedbacks, :only => [:index]
    resources :companies_resumes, :only => [:index, :destroy] do
      member do
        post :change_status
      end
      collection do
        post :mass_reject
        delete :mass_destroy
      end
    end
    resources :notifications, :only => [:index]
    resources :folders
  end


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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
