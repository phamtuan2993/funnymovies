require 'rails_helper'

describe V1::Movies do
  describe 'POST /' do
    before do
      allow_any_instance_of(Api::Authenticable).to receive(:current_user).and_return(current_user)
    end

    context 'unauthenticated' do
      let(:current_user) { nil }
      let(:url) { 'https://www.youtube.com/watch?v=J8nJnIxSLB0' }

      it 'returns 401' do
        post '/api/v1/movies', params: { url: url }

        expect(response.status).to eq(401)
      end
    end

    context 'authenticated' do
      let(:current_user) { build(:user) }

      before do
        allow(ShareMovie).to receive(:new).and_call_original
        allow_any_instance_of(ShareMovie).to receive(:call)
        allow_any_instance_of(ShareMovie).to receive(:movie).and_return(stubbed_movie)
      end

      let(:url) { 'https://www.youtube.com/watch?v=J8nJnIxSLB0' }
      let(:stubbed_movie) { build(:movie, url: url) }

      it 'calls service and return result' do
        post '/api/v1/movies', params: { url: url }

        expect(ShareMovie).to have_received(:new).with(shared_by: current_user, url: url)

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)['data']).to include(
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

        it 'calls service and return errors' do
          post '/api/v1/movies', params: { url: url }

          expect(ShareMovie).to have_received(:new).with(shared_by: current_user, url: url)

          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['error']).to include(
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
