#encoding: utf-8

FactoryGirl.define do
  factory :competition do
    sequence :name do |n|
      "Aachen Open 200#{n}"
    end
    starts_at Date.new(2010, 2, 12)
    ends_at Date.new(2010, 2, 14)
    user
    closed false
  end

  factory :event do
    sequence :name do |n|
      "#{n}x#{n}x#{n}"
    end
    sequence :short_name do |n|
      n.to_s
    end
  end

  factory :schedule do
    event
    competition
    starts_at Time.utc(2010, 1, 1, 13, 0)
    ends_at Time.utc(2010, 1, 1, 13, 30)
    day 0
    registerable true # FIXME is getting ignored
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
    role "organizer"
    factory :admin do
      role "admin"
    end
  end

  factory :competitor do
    sequence :first_name do |n|
      "Peter#{n}"
    end
    sequence :last_name do |n|
      "Müller#{n}"
    end
    date_of_birth Date.new(1981, 4, 21)
    gender "m"
    factory :competitor_with_wca_id do
      wca_id "2008MUEL01"
    end
  end

  factory :registration do
    competition
    competitor
    email "muh@cow.com"
  end
end
