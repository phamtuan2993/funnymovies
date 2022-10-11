class ShareMovie < ServiceBase
  attr_reader :shared_by, :url, :movie

  def initialize(shared_by:, url:)
    super
    @shared_by = shared_by
    @url = url
  end

  def call
    @movie = Movie.new(shared_by: shared_by, url: url)
    return add_error(@movie.errors.full_messages) unless movie.valid?

    # move this part to async worker later
    movie_data = extract_url_data(url)
    return unless success?

    @movie.assign_attributes(
      title: movie_data['title'],
      description: movie_data['description']
    )
    @movie.save
  end

  private

  def extract_url_data(url)
    raise "ENV['GG_API_KEY'] is empty" if ENV['GG_API_KEY'].blank?

    movie_id = URI.decode_www_form(URI(url).query || '').to_h['v']
    HTTParty.get(
      "https://www.googleapis.com/youtube/v3/videos"\
      "?id=#{movie_id}&key=#{Figaro.env.GG_API_KEY}&fields=items(snippet(title,description))&part=snippet"
    ).parsed_response['items'][0]['snippet']
  rescue ActiveSupport::Dependencies::Blamable, Exception => e
    code = Time.now.to_f
    Rails.logger.info('='*20)
    Rails.logger.error("#{code} - #{e.message}\n↳ #{e.backtrace[0]}")
    Rails.logger.info('='*20)

    add_error(e.class.new("#{code} - #{e.message}"))
  end
end
