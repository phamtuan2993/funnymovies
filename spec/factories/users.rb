FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'funnymovies' }
  end
end
