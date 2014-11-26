class User < ActiveRecord::Base
  has_many :books, foreign_key: :owner_id

  def admin?
    self.admin == 't'
  end
end
