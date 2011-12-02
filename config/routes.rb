Newschool::Application.routes.draw do
  get "posts/new"

  get "blog/index"

  root :to => "blog#index"

  resources :posts
end
