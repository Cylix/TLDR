FactoryGirl.define do

  factory :content do
    title       "Some content title"
    description "Some content description"
    url         "http://some.url/to/the/content"

    association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :build
  end

  factory :content_with_user_with_source, class: Content do
    title       "Some content title"
    description "Some content description"
    url         "http://some.url/to/the/content"

    # association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :create

    after(:build) { |content| content.user = content.source.user }
  end

  factory :content_edited, class: Content do
    title       "Some content title Edited"
    description "Some content description Edited"
    url         "http://some.url/to/the/content/edited"

    association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :build
  end

  factory :content_with_user_with_source_edited, class: Content do
    title       "Some content title Edited"
    description "Some content description Edited"
    url         "http://some.url/to/the/content/edited"

    # association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :create

    after(:build) { |content| content.user = content.source.user }
  end

end
