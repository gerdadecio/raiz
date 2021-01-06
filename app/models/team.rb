class Team < ApplicationRecord
  include AccountHandler

  validates :name, presence: true
end
