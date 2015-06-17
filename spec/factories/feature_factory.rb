FactoryGirl.define do
  factory :feature do
    project
    title     { Faker::Lorem.sentence }
    status    { Feature.status.values[rand(3)] }
    priority  { rand(9)+1 }
    point     { rand(10) }
  end
end
