FactoryGirl.define do

  factory :source do
    name          'YT Channel'
    description   'YT Channel feed'
    url           'https://youtube.com/channel/xxx'
    rss_feed      'https://youtube.com/channel/xxx/rss'

    association :user, factory: :user, strategy: :build
  end

  factory :source_with_user, class: Source do
    name          'YT Channel'
    description   'YT Channel feed'
    url           'https://youtube.com/channel/xxx'
    rss_feed      'https://youtube.com/channel/xxx/rss'

    association :user, factory: :user, strategy: :create
  end

  factory :source_edited, class: Source do
    name          'YT Channel Edited'
    description   'YT Channel Edited feed'
    url           'https://youtube.com/channel/yyy'
    rss_feed      'https://youtube.com/channel/yyy/rss'

    association :user, factory: :user, strategy: :build
  end

  factory :source_edited_with_user, class: Source do
    name          'YT Channel Edited'
    description   'YT Channel Edited feed'
    url           'https://youtube.com/channel/yyy'
    rss_feed      'https://youtube.com/channel/yyy/rss'

    association :user, factory: :user, strategy: :create
  end

end
