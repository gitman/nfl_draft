class OrdersController < ApplicationController
  def index
    @players = Player.last_three_picks
    @order = Order.where(:chosen => false).first
  end
end
