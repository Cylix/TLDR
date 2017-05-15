Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Root
  root to: 'static_pages#home'

  # sources
  resources :sources, except: :show

  # contents
  resources :contents, only: [:index, :update]
  # contents filtering
  ## By source
  get '/sources/:source_id/contents' => 'contents#index', as: :source_contents
  ## Type (snoozed/done/trashed)
  get '/contents/:category' => 'contents#index', as: :filter_contents

end
