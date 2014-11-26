class Book < ActiveRecord::Base
  belongs_to :owner, class: User, foreign_key: :owner_id

  validates :name, presence: true
  validates :author, presence: true
  validates :year, presence: true

  scope :available, -> { where("borrowed_date < ? OR borrowed_date IS NULL", 7.days.ago) }

  def self.search query
    available.where("name like ?", "%#{ query }%")
  end

  def available?
    borrowed_date < 7.days.ago || borrowed_date.nil?
  end

  def borrow!
    update( borrowed_date: DateTime.now )
  end
end
