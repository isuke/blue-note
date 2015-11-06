FactoryGirl.define do
  factory :project do
    name { Faker::App.name }

    trait :with_features do
      transient { features_count 3 }
      transient { features { create_list(:feature, features_count) } }
      after(:create) do |project, evaluator|
        create_list(:feature, evaluator.features_count, project: project)
      end
    end

    trait :with_iterations do
      transient { iterations_count 3 }
      transient { iterations { create_list(:iteration, iterations_count) } }
      after(:create) do |project, evaluator|
        create_list(:iteration, evaluator.iterations_count, project: project)
      end
    end
  end
end
