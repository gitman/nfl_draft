NflDraft::Application.routes.draw do
  match 'undrafted_players' => 'players#undrafted_players', :as => :undrafted_players

  get 'orders/index'

  root :to => 'orders#index'
end
