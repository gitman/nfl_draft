class PlayersController < ApplicationController
  def undrafted_players
    @players = Player.undrafted
  end
end
