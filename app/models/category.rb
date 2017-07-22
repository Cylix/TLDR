class Category < ApplicationRecord

  # associations
  belongs_to :user
  has_many :contents

  # validations
  validates :name, presence: true
  validates :name, uniqueness: {scope: :user_id}

  # association validations
  validates_presence_of :user
  validates_associated  :user

  # default scope
  default_scope { order(name: :asc) }

end
