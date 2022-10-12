# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#

User.create(email: 'phamtuan@gmail.com', password: 'funnymovies')
User.create(10.times.map { { email: Faker::Internet.email, password: 'funnymovies' } })

def random_url
  ['https://www.youtube.com/watch?v=J8nJnIxSLB0', 'https://www.youtube.com/watch?v=JUZZeFOO2yw', 'https://www.youtube.com/watch?v=B3TlJyJcd34&t=397s', 'https://www.youtube.com/watch?v=qWN0_cBvfHo'].sample
end

User.find_each do |user|
  Movie.create(
    (5..10).to_a.sample.times.map do
      url = random_url
      {
        embedded_id: url.match(/v=(.*)/)[1],
        shared_by: user,
        url: url,
        title: Faker::Movie.title,
        description: Faker::Movie.quote.truncate(20)
      }
    end
  )
end
