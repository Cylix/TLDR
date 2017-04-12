FactoryGirl.define do

  factory :content do
    title       "Some content title"
    description "Some content description"

    association :user,   factory: :user,       strategy: :build
    association :source, factory: :rss_source, strategy: :build
  end

end
