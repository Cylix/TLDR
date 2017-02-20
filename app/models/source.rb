class Source < ApplicationRecord

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

  # returns hash associating source type to its related fields
  def self.fields_by_source_type
    {}.tap do |res|
      descendants.each { |s| res[s.to_s] = s.type_specific_fields }
    end
  end

  # returns whether the current source has an allowed type
  def has_allowed_type?
    Source::descendants.map(&:to_s).include? type
  end

  # Return the synchronizer associated to that source
  # Must be implemented by child classes
  def self.synchronizer
    raise "No synchronizer defined for source type '#{self.to_s}'"
  end

  # returns the list of fields specific to this particular type of source
  # Should be implemented by child classes
  def self.type_specific_fields
    %w[]
  end

  private

  # validates url format
  def validates_url_format
    errors.add(:url, :invalid) unless URLHelper::valid_url?(url)
  end

end

# Load sources subclasses of the source directory
# This would have the effect of initializing @@allowed_types
Dir[File.join(File.dirname(__FILE__), 'source', '*.rb')].each {|file| require_dependency file }
