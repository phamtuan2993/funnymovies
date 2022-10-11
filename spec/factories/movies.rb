FactoryBot.define do
  factory :movie do
    association :shared_by, factory: :user
    url { Faker::Internet.url }
    title { Faker::Movie.title }
    description { Faker::Movie.quote.truncate(20) }
  end
end
