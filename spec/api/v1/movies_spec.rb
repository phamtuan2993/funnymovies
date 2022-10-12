require 'rails_helper'

describe V1::Movies do
  before do
    allow_any_instance_of(Helpers::Authenticable).to receive(:current_user).and_return(current_user)
  end

  let(:json_response) { JSON.parse(response.body) }
  let(:current_user) { create(:user) }
  let(:url) { 'https://www.youtube.com/watch?v=J8nJnIxSLB0' }

  describe 'GET /' do
    let!(:movies) { create_list(:movie, 3, shared_by: current_user) }

    it 'returns data correctly' do
      get '/api/v1/movies'

      expect(response.status).to eq(200)
      expect(json_response['data']).to match_json_schema('v1/movies')
      expect(json_response['data']).to include(
        "pageIndex" => 1,
        "itemsPerPage" => 20,
        "currentItemCount" => 3,
        "totalItems" => 3,
        "totalPages" => 1
      )
      expect(json_response['data']['items']).to match_array([
        include('id' => movies[0].id),
        include('id' => movies[1].id),
        include('id' => movies[2].id),
      ])
    end

    it 'returns data with pagination' do
      get '/api/v1/movies', params: { items_per_page: 2, page_index: 2 }

      expect(json_response['data']).to include(
        "pageIndex" => 2,
        "itemsPerPage" => 2,
        "currentItemCount" => 1,
        "totalItems" => 3,
        "totalPages" => 2
      )
      expect(json_response['data']['items']).to match_array([
        include('id' => movies[2].id),
      ])
    end
  end

  describe 'POST /' do
    context 'unauthenticated' do
      let(:current_user) { nil }

      it 'returns 401' do
        post '/api/v1/movies', params: { url: url }

        expect(response.status).to eq(401)
      end
    end

    context 'authenticated' do
      before do
        allow(ShareMovie).to receive(:new).and_call_original
        allow_any_instance_of(ShareMovie).to receive(:call)
        allow_any_instance_of(ShareMovie).to receive(:movie).and_return(stubbed_movie)
      end

      let(:stubbed_movie) { build(:movie, id: 101, url: url, shared_by_id: current_user.id) }

      it 'calls service and return result' do
        post '/api/v1/movies', params: { url: url }

        expect(ShareMovie).to have_received(:new).with(shared_by: current_user, url: url)

        expect(response.status).to eq(201)
        expect(json_response['data']).to match_json_schema('v1/movie_item')
        expect(json_response['data']).to include(
          'id' => stubbed_movie.id,
          'url' => url,
          'shared_by_id' => current_user.id
        )
      end

      context 'service returns errors' do
        before do
          allow(ShareMovie).to receive(:new).and_return(
            instance_double(
              ShareMovie,
              call: nil,
              success?: false,
              errors: ['some error']
            )
          )
        end

        it 'calls service and returns errors' do
          post '/api/v1/movies', params: { url: url }

          expect(ShareMovie).to have_received(:new).with(shared_by: current_user, url: url)

          expect(response.status).to eq(422)
          expect(json_response['error']).to include(
            'code' => 422,
            'errors' => [{
              'message' => 'some error'
            }]
          )
        end
      end
    end
  end
end
