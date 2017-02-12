class Source < ApplicationRecord

  include URLHelper

  # associations
  belongs_to :user

  # validations
  validates :type,        inclusion: { in: Proc.new { descendants.map(&:to_s) } }
  validates :name,        length: { minimum: 2 }, presence: true
  validates :description, length: { minimum: 0, allow_nil: false, message: I18n.t("activerecord.errors.models.source.description.nil") }
  validates :url,         presence: true
  validate  :validates_url_format
  # association validations
  validates_presence_of :user
  validates_associated  :user

  private

  # validates url format
  def validates_url_format
    errors.add(:url, :invalid) unless valid_url?(url)
  end

end

# Load sources subclasses of the source directory
# This would have the effect of initializing @@allowed_types
Dir[File.join(File.dirname(__FILE__), 'source', '*.rb')].each {|file| require_dependency file }
