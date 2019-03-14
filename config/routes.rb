Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/token/:id', to: 'tokenmetadata#tokeninfo'
  get '/token/:id/image/:gene', to: 'tokenmetadata#token_image'
  get '/icon', to: 'tokenmetadata#icon'
end
