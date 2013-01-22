class Player < ActiveRecord::Base
  attr_accessible :name, :position

  validates_presence_of :name, :position

  has_one :ownership
  has_one :team, :through => :ownership

  def self.last_three_picks
    where('id in (?)', Ownership.all.map(&:player_id)).limit(3).order('created_at DESC')
  end

  def self.undrafted
    where('id not in (?)', Ownership.all.map(&:player_id)).order('position ASC, name ASC').group_by(&:position)
  end
end
