FactoryGirl.define do

  factory :content do
    title       "Some content title"
    description "Some content description"
    url         "http://some.url/to/the/content"

    association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :build
  end

end
