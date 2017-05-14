class Content < ApplicationRecord

  # associations
  belongs_to :user
  belongs_to :source

  # validations
  validates :title,           presence: true
  validates :url,             presence: true
  validates :pinned,          inclusion: { in: [true, false] }
  validates :synchronized_at, presence: true
  validate  :validates_url_format

  # association validations
  validates_presence_of :user
  validates_associated  :user
  validates_presence_of :source
  validates_associated  :source

  # default scope
  default_scope { order(created_at: :desc) }

  # validates url format
  def validates_url_format
    errors.add(:url, :invalid) unless URLHelper::valid_url?(url)
  end

end
