Rails.application.routes.draw do
  get 'new',   to: 'games#new', as: :new
  get 'clear',  to: 'games#reset', as: :clear

  get 'score', to: 'games#score'
  post 'score',  to: 'games#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
