Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'app#main'
  get 'im', to: 'app#im'
  get 'login', to: 'app#login'
  post 'login', to: 'app#authorisation', as: :users
  get 'logout', to: 'app#logout'
  get 'settings', to: 'app#settings'
  patch 'user.:id(.:format)', to: 'app#user_update', as: :user


  get 'api/userByToken', to: 'api#userGetByToken', as: :getUserByToken
  get 'api/userById', to: 'api#userGetById', as: :getUserById
  get 'api/message/send', to: 'api#addMessage'

end
