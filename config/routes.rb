Rails.application.routes.draw do

  # New way user registration
  devise_scope :user do
    get "/sign_in" => "devise/sessions#new"
    get "(/:user)/sign_up/(:affiliate)" => "users/registrations#new", as: "new_user_registration"
    get "/:id/sign_out" => "devise/sessions#destroy"
  end


  authenticated :user, ->(u) { u.role == 'admin' } do
    root to: "users/visits#index", as: :admin_root
    namespace :users do
      resources :visits
    end
  end

  get "admin/week_percentages", to: 'admin#week_percentages', as: 'admin_week_percentages'
  get "admin/index", to: 'admin#index', as: 'admin_index'

  # for affiliates investors dashboard
  namespace :users do
    resources :users_investments, except: [:edit, :update]
    resources :affiliates
    resources :campaigns
  end

  # New way user registrations
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users do
    resources :investmentss
    resources :wallets
    get 'wallets/show'
  end

  resources :wallets, only: [:show] do
    resources :transactions, only: [:new, :create, :destroy]
    resources :users do
      resources :transactions, only: [:new, :create, :destroy]
    end
  end

  resources :transactions, only: [:index, :edit, :update, :show]
  resources :deposits, only: [:index, :edit, :update, :show]
  post "preset_investment", to: "investments#preset_investment", as: :preset_investment
  resources :investments do
    resources :payouts, only: [:index]
  end

  # Investment create
  post "investment/get_end_date", to: "investments#get_end_date"
  post "investment/get_frequency", to: "investments#get_frequency"
  post "investment/expected_return", to: "investments#expected_return"
  post "investment/get_range", to: "investments#get_range"
  post "investment/get_payment_method_id", to: "investments#get_payment_method_id"
  post "investment/confirm", to: "investments#confirm"
  post "investment/get_edit_investment", to: "investments#get_edit_investment"
  post "investment/get_frequency_title", to: "investments#get_frequency_title"
  post "investment/get_status", to: "investments#get_status"

  get :certificate, to: "investments#certificate"
  resources :week_percentages
  resources :payouts, only: [:index, :show]

  resources :dashboards, only: [:index]

  resources :performance, ohly: [:index]
  post "performance/chartdata", to: "performance#chartdata"
  # Admin user profile update
  get "profile/:id/edit", to: "profiles#edit", as: :edit_user_profile
  patch "profiles/:id", to: "profiles#update", as: :update_user_profile
  post "profiles/:id", to: "profiles#update"
  put "profiles/:id", to: "profiles#update"
  post "profile/password_update/:id", to: "profiles#password_update", as: :password_update_user_profile
  #put "profile/password_update/:id", to: "profiles#password_update", as: :password_update_user_profile

  get "support", to: "profiles#edit", as: :contact_support
  get "free_coins", to: "profile#edit", as: :free_coins

  # Profiles
  get "profile/edit", to: "profiles#edit", as: :edit_profile
  get 'profile/auth_factor', to: "profiles#auth_factor", as: :auth_factor
  get 'profile/enable_two_factor', to: "profiles#enable_two_factor", as: :enable_two_factor
  get 'profile/resend_otp', to: "profiles#resend_otp", as: :resend_otp

  # Phone Verification
  post "profile/send_phone_verification", to: "profiles#send_phone_verification"
  post "profile/verify_phone", to: "profiles#verify_phone"
  post "profile/resend_code", to: "profiles#send_phone_verification"
  #patch "profile/update", to: "profiles#update", as: :update_profile
  get "profiles", to: "profiles#index", as: :proifles
  post "profile/update", to: "profiles#update", as: :update_profile
  post "profile/password_update", to: "profiles#password_update", as: :password_update_profile
  delete "profile", to: "profiles#destroy", as: :profile_destroy

  # Phone Numbers
  resources :phone_numbers, only: [:create, :destroy]
  resources :number_verifications, only: [:new, :create]

  # admin user add phone number
  post "phone_numbers/:id", to: "phone_numbers#create", as: :user_phone_number
  delete "phone_numners", to: "phone_numbers#destory", as: :destroy_user_phone_number

  # Payments
  get 'payments_all', to: "payments#index", as: :payments_all
  get "payment/:id/show", to: "payments#show", as: :payment_show
  get 'payments', to: "payments#create"
  get 'payments/:id/address/:coin', to: "payments#address", as: :payment_address
  get 'payment/:id/status', to: "payments#status", as: :payment_status
  post 'payment/:id/callback', to: "payments#callback", as: :payment_callback
  post 'payments/:id/callback', to: "payments#callback", as: :payments_callback

  # routes for ajax calls
  match 'expected_return', to: "expected_return#earning", as: :expected_return, via: :post
  match 'expected_return_25', to: "expected_return#per_month_25", as: :expected_return_25, via: :post
  match 'currency_converter', to: "currency_converter#convert", as: :currency_converter, via: :get
  match 'currency_in_crypto', to: "currency_converter#show_crypto", as: :currency_in_crypto, via: :get

  # Wizard Investment
  resource :investment do
    get :name
    get :timeframe
    post :validate_step
  end
  resource :wizard_investment do
    get :start
    get :plan
    get :name
    get :timeframe
    get :payout
    get :amount
    get :payment
    get :review
    get :pay
    get :cancel
    get :ready
    get :continue
    get :return_expected_return_value

    post :validate_step
  end

  root 'dashboards#index'

  # APIs
  mount API::Base, at: '/'
  mount GrapeSwaggerRails::Engine, at: '/documentation'
end
