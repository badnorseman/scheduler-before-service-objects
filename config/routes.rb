Rails.application.routes.draw do
  # The priority is based upon order of creation: first created has highest priority.
  # See how all your routes lay out with 'rake routes'. Read more: http://guides.rubyonrails.org/routing.html

  scope "/api" do
    mount_devise_token_auth_for "User", at: "/auth"
    resources :availabilities, except: [:new, :edit]
    resources :bookings, except: [:new, :edit]
    resources :users, except: [:new, :edit]
    resources :roles, except: [:new, :edit]
  end

  root to: "welcome#index"
end
