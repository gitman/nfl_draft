class Ownership < ActiveRecord::Base
  attr_accessible :player_id, :team_id

  validates_presence_of :player
  validates_presence_of :team

  belongs_to :order
  belongs_to :player
  belongs_to :team
end
