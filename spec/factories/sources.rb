FactoryGirl.define do

  factory :source do
    name          'YT Channel'
    description   'YT Channel feed'
    url           'https://youtube.com/channel/xxx'
    rss_feed      'https://youtube.com/channel/xxx/rss'
  end

  factory :source_edited do
    name          'YT Channel Edited'
    description   'YT Channel Edited feed'
    url           'https://youtube.com/channel/yyy'
    rss_feed      'https://youtube.com/channel/yyy/rss'
  end

end
