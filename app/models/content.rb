class Content < ApplicationRecord

  # Enum values for category
  CATEGORY_VALUES = [:inbox, :snoozed, :done, :trashed]
  enum category: CATEGORY_VALUES

  # associations
  belongs_to :user
  belongs_to :source

  # validations
  validates :title,           presence: true
  validates :url,             presence: true
  validates :is_pinned,       inclusion: { in: [true, false] }, allow_nil: false
  validates :synchronized_at, presence: true
  validates :category,        inclusion: { in: CATEGORY_VALUES.map(&:to_s) }
  validate  :validates_url_format

  # association validations
  validates_presence_of :user
  validates_associated  :user
  validates_presence_of :source
  validates_associated  :source

  # default scope
  default_scope { order(created_at: :desc) }

  # is content done?
  def is_done?
    self.category.to_sym == :done
  end

  # is content snoozed?
  def is_snoozed?
    self.category.to_sym == :snoozed
  end

  # is content trashed?
  def is_trashed?
    self.category.to_sym == :trashed
  end

  # validates url format
  def validates_url_format
    errors.add(:url, :invalid) unless URLHelper::valid_url?(url)
  end

end
