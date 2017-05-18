FactoryGirl.define do

  factory :content do
    title           "Some content title"
    description     "Some content description"
    url             "http://some.url/to/the/content"
    published_at    Time.now
    synchronized_at Time.now
    is_pinned       false # leave false to avoid ordering issues during tests

    association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :build
  end

  factory :content_with_user_with_source, class: Content do
    title           "Some content title"
    description     "Some content description"
    url             "http://some.url/to/the/content"
    published_at    Time.now
    synchronized_at Time.now
    is_pinned       false # leave false to avoid ordering issues during tests

    # association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :create

    after(:build) { |content| content.user = content.source.user }
  end

  factory :content_edited, class: Content do
    title           "Some content title Edited"
    description     "Some content description Edited"
    url             "http://some.url/to/the/content/edited"
    published_at    (Time.now - 1.day)
    synchronized_at (Time.now - 1.day)
    is_pinned       false # leave false to avoid ordering issues during tests

    association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :build
  end

  factory :content_edited_2, class: Content do
    title           "Some content title with another edit"
    description     "Some content description with another edit"
    url             "http://some.url/to/the/content/with/another/edit"
    published_at    (Time.now - 2.day)
    synchronized_at (Time.now - 2.day)
    is_pinned       false # leave false to avoid ordering issues during tests

    association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :build
  end

  factory :content_with_user_with_source_edited, class: Content do
    title           "Some content title Edited"
    description     "Some content description Edited"
    url             "http://some.url/to/the/content/edited"
    published_at    (Time.now - 1.day)
    synchronized_at (Time.now - 1.day)
    is_pinned       false # leave false to avoid ordering issues during tests

    # association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :create

    after(:build) { |content| content.user = content.source.user }
  end

end
