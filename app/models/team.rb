class Team < ActiveRecord::Base
  attr_accessible :division, :name

  validates_presence_of :name

  has_many :ownerships
  has_many :players, :through => :ownerships
  has_many :orders

  def acquire(player)
    players << player
  end
end
