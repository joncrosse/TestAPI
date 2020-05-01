Rails.application.routes.draw do

  get 'welcome/index'
  root 'welcome#index'

  get 'api/status'
  post 'api/status'

  #get 'api/seeuser/:id'
  post 'api/seeuser/:id', to: 'api#seeuser'
  
  post 'api/createuser'
end
