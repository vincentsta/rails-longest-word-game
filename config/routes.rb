Rails.application.routes.draw do
  get 'game', to: 'longest_word#game'
  get 'score', to: 'longest_word#score'
  root to: 'longest_word#init'
  post 'init', to: 'longest_word#usr_name'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
