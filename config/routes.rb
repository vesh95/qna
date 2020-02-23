Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    post :voteup, on: :member
    post :votedown, on: :member
    delete :revote, on: :member
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable, except: %i[index show new] do
      patch :best, on: :member
      get :load, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :users, only: %i[index show]
end
