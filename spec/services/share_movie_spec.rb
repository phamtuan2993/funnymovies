require 'rails_helper'

describe ShareMovie do
  before do
    allow(Figaro.env).to receive(:GG_API_KEY).and_return(gg_api_key)
    allow(HTTParty).to receive(:get).with(
      "https://www.googleapis.com/youtube/v3/videos"\
      "?id=J8nJnIxSLB0&key=my_gg_api_key&fields=items(snippet(title,description))&part=snippet"
    ).and_return(
      instance_double(
        HTTParty::Response,
        success?: true,
        parsed_response: {
          'items' => [
            {
              'snippet' => {
                'title' => 'movie title',
                'description' => 'movie description'
              }
            },
          ],
        },
        code: 200
      )
    )
  end

  let(:gg_api_key) { 'my_gg_api_key' }
  let(:url) { 'https://www.youtube.com/watch?v=J8nJnIxSLB0' }
  let(:shared_by) { create(:user) }
  let(:service) { ShareMovie.new(shared_by: shared_by, url: url) }

  it 'creates a new movies with data fetch from given url' do
    expect { service.call }
      .to change { Movie.count }.by(1)

    expect(Movie.order(created_at: :asc).last).to have_attributes(
      title: 'movie title',
      description: 'movie description',
      url: url,
      shared_by: shared_by
    )
  end

  context 'bad cases' do
    context 'given data is invalid' do
      let(:url) { 'hacking_url' }

      it 'does nothing and returns errors' do
        expect { service.call }
          .not_to change { Movie.count }

        expect(service.success?).to be(false)
        expect(service.errors).not_to be_empty
      end
    end

    context 'failed to fetch data' do
      before do
        allow(HTTParty).to receive(:get).with(
          "https://www.googleapis.com/youtube/v3/videos"\
          "?id=J8nJnIxSLB0&key=my_gg_api_key&fields=items(snippet(title,description))&part=snippet"
        ).and_return(
          instance_double(
            HTTParty::Response,
            success?: false,
            parsed_response: nil,
            code: 422
          )
        )
      end

      it 'does nothing and returns errors' do
        expect { service.call }
          .not_to change { Movie.count }

        expect(service.success?).to be(false)
        expect(service.errors).not_to be_empty
      end
    end
  end
end
