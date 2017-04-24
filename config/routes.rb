Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Root
  root to: 'static_pages#home'

  # sources
  resources :sources, except: :show

  # contents
  resources :contents, only: :index
  # contents filtering
  get '/sources/:source_id/contents' => 'contents#index', as: :source_contents

end
