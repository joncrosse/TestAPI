Rails.application.routes.draw do


  get 'api/status'
  post 'api/status'

  #get 'api/seeuser/:id'
  post 'api/seeuser/:id', to: 'api#seeuser'
  
  post 'api/createuser'

  post 'api/unfollow/:id', to: 'api#unfollow'

  post 'api/follow/:id', to: 'api#follow'

  post 'api/poststory'

  post 'api/block/:id', to: 'api#block'

  post 'api/reprint/:id', to: 'api#reprint'
end
