FactoryGirl.define do

  factory :user do
    first_name            'John'
    last_name             'Doe'
    email                 'john.doe@mail.com'
    password              'password'
    password_confirmation 'password'
  end

  factory :user_edited, class: User do
    first_name            'JohnEdited'
    last_name             'DoeEdited'
    email                 'john.doe.edited@mail.com'
    password              'passwordEdited'
    password_confirmation 'passwordEdited'
  end

end
