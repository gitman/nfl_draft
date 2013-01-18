class Player < ActiveRecord::Base
  attr_accessible :name, :position

  validates_presence_of :name, :position

  has_one :ownership
  has_one :team, :through => :ownership
end
