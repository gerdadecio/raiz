class Stock < ApplicationRecord
  include AccountHandler

  validates :code, :name, :company, presence: true
end
