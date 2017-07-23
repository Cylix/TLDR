class Content < ApplicationRecord

  # Enum values for status
  STATUS_VALUES = [:inbox, :snoozed, :done, :trashed]
  enum status: STATUS_VALUES

  # associations
  belongs_to :user
  belongs_to :source
  belongs_to :category, optional: true

  # validations
  validates :title,           presence: true
  validates :url,             presence: true
  validates :is_pinned,       inclusion: { in: [true, false] }, allow_nil: false
  validates :synchronized_at, presence: true
  validates :status,          inclusion: { in: STATUS_VALUES.map(&:to_s) }
  validate  :validates_url_format
  validate  :validates_user_category

  # association validations
  validates_presence_of :user
  validates_associated  :user
  validates_presence_of :source
  validates_associated  :source

  # default scope
  default_scope { order(created_at: :desc) }

  # is content categorized
  def is_categorized?
    self.category.present?
  end

  # is content categorized in given category
  def is_categorized_in?(category)
    self.category_id == category.id
  end

  # is content done?
  def is_done?
    self.status.to_sym == :done
  end

  # is content snoozed?
  def is_snoozed?
    self.status.to_sym == :snoozed
  end

  # is content trashed?
  def is_trashed?
    self.status.to_sym == :trashed
  end

  # validates url format
  def validates_url_format
    errors.add(:url, :invalid) unless URLHelper::valid_url?(url)
  end

  # validates that the category belongs to the user
  def validates_user_category
    errors.add(:category, :invalid) if self.category_id.present? && !self.user.categories.collect { |c| c.id }.include?(self.category_id)
  end

end
