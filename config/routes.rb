Rails.application.routes.draw do
  # get 'home/index'
  root :to => "home#index", via: [:get, :post]
  get '/issue_cycle' => "home#issue_cycle"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
