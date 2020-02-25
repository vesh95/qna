Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    post :voteup, on: :member
    post :votedown, on: :member
    delete :revote, on: :member
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, concerns: %i[votable commentable], except: %i[index new] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :users, only: %i[index show]
end
