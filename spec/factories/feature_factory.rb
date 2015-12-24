FactoryGirl.define do
  factory :feature do
    project
    iteration
    title     { Faker::Lorem.sentence }
    status    { Feature.status.values[rand(3)] }
    sequence(:priority) { |n| n + 1 }
    point     { rand(10) }
  end
end
