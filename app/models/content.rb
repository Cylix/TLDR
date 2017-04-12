class Content < ApplicationRecord

  # associations
  belongs_to :user
  belongs_to :source

  # validations
  validates :title, presence: true
  validates :url,   presence: true
  validate  :validates_url_format

  # validates url format
  def validates_url_format
    errors.add(:url, :invalid) unless URLHelper::valid_url?(url)
  end

end
