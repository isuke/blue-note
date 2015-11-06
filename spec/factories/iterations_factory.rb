FactoryGirl.define do
  factory :iteration do
    project
    sequence(:number) { |n| n + 1 }
    start_at { Faker::Date.between(5.days.ago     , 1.days.ago)      }
    end_at   { Faker::Date.between(Time.zone.today, 5.days.from_now) }
  end
end
