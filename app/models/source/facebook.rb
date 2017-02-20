class Source::Facebook < Source

  # Return the synchronizer associated to that source
  def self.synchronizer
    Synchronizer::Facebook.new self
  end

  # returns the list of fields specific to this particular type of source
  def self.type_specific_fields
    %w[]
  end

end
