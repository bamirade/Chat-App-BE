Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post 'signup', to: 'registrations#create'
  post 'reconfirm_email', to: 'registrations#user_reconfirm'
  post 'reset_password', to: 'registrations#password_reset'
  get 'confirm_email/:token', to: 'registrations#confirm_email'

  post 'login', to: 'sessions#login'
end
