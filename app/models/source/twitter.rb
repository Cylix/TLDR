class Source::Twitter < Source

  # returns the list of fields specific to this particular type of source
  def self.type_specific_fields
    %w[]
  end

end
