NflDraft::Application.routes.draw do
  get "orders/index"

  root :to => 'orders#index'
end
