class Content < ApplicationRecord

  # associations
  belongs_to :user
  belongs_to :source

  # validations
  validates :title, presence: true

end
