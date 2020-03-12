require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  devise_for :users, controllers: {
                                    omniauth_callbacks: 'oauth_callbacks',
                                    confirmations: 'email_confirmations',
                                    registrations: 'registrations'
                                  }
  root to: 'questions#index'

  get :search, to: 'search#index'

  concern :votable do
    post :voteup, on: :member
    post :votedown, on: :member
    delete :revote, on: :member
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :subscriptions, only: %i[create destroy], shallow: true

    resources :answers, shallow: true, concerns: %i[votable commentable], except: %i[index new] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :users, only: %i[index show]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index create show update destroy]
      end
    end
  end
end
