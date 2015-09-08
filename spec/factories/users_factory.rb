FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.safe_email }
    password { Faker::Internet.password(4) }
    password_confirmation { password }

    trait :with_projects do
      transient { projects { create_list(:project, 5) } }
      after :create do |user, evaluator|
        evaluator.projects.each do |project|
          create(:member, user: user, project: project)
        end
      end
    end
  end
end
