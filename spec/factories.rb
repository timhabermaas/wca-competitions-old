FactoryGirl.define do
  factory :competition do
    sequence :name do |n|
      "Aachen Open 200#{n}"
    end
    starts_at Date.new(2010, 2, 12)
    ends_at Date.new(2010, 2, 14)
    user
  end

  factory :event do
    name "3x3x3"
  end

  factory :news do
    content "Sorry, we're closed, BITCHES! MUHAHAHAHA"
    competition
    user
  end

  factory :user do
    sequence :name do |n|
      "user#{n}"
    end
    sequence :email do |n|
      "foo#{n}@bar.com"
    end
    password "secret"
    password_confirmation "secret"
  end
end
