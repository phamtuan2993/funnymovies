class FunnyMoviesApi < Grape::API
  format :json
  prefix :api

  namespace '/v1' do
    mount V1::Movies
    mount V1::Auth
  end
end
