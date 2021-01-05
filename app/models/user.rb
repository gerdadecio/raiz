class User < ApplicationRecord
  include AccountHandler

  def full_name
    # NOTES: We can move this into a decorator later on
    [first_name, last_name].join(' ')
  end

end
