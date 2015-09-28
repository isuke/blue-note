FactoryGirl.define do
  factory :member do
    user
    project
    role :admin
  end
end
