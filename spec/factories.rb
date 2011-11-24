FactoryGirl.define do
  factory :competition do
    name "Aachen Open 2010"
    starts_at Date.new(2010, 2, 12)
    ends_at Date.new(2010, 2, 14)
  end

  factory :event do
    name "3x3x3"
  end
end
