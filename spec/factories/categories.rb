FactoryGirl.define do

  factory :category do
    name 'bitcoin'
  end

  factory :category_edited, class: Category do
    name 'ethereum'
  end

end
