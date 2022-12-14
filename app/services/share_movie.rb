class ShareMovie < ServiceBase
  attr_reader :shared_by, :url, :movie

  def initialize(shared_by:, url:)
    super
    @shared_by = shared_by
    @url = url
  end

  def call
    validate_upload_limit
    return unless success?

    @movie = Movie.new(shared_by: shared_by, url: url)
    return add_error(@movie.errors.full_messages) unless movie.valid?

    # move this part to async worker later
    movie_data = extract_url_data(url)
    return unless success?

    @movie.assign_attributes(
      embedded_id: movie_data['id'],
      title: movie_data['title'],
      description: movie_data['description']
    )
    @movie.save
  end

  private

  PER_DAY_UPLOAD_LIMIT = (ENV['PER_DAY_UPLOAD_LIMIT'] || 50).to_i
  PER_USER_PER_DAY_UPLOAD_LIMIT = (ENV['PER_USER_PER_DAY_UPLOAD_LIMIT'] || 5).to_i

  def validate_upload_limit
    user_daily_upload_limit_exceeded =
      shared_by.movies
        .where("created_at > ?", Date.yesterday)
        .limit(PER_USER_PER_DAY_UPLOAD_LIMIT)
        .count == PER_USER_PER_DAY_UPLOAD_LIMIT

    if user_daily_upload_limit_exceeded
      return add_error(I18n.t('error.movies.exceeded_user_daily_upload_limit', limit: PER_USER_PER_DAY_UPLOAD_LIMIT))
    end

    daily_upload_limit_exceeded =
      Movie.where("created_at > ?", Date.yesterday).limit(PER_DAY_UPLOAD_LIMIT).count == PER_DAY_UPLOAD_LIMIT

    if daily_upload_limit_exceeded
      return add_error(I18n.t('error.movies.exceeded_daily_upload_limit', limit: PER_DAY_UPLOAD_LIMIT))
    end
  end

  def extract_url_data(url)
    raise "GG_API_KEY is empty" if Figaro.env.GG_API_KEY.blank?

    movie_id = URI.decode_www_form(URI(url).query || '').to_h['v']

    raw_data = HTTParty.get(
      "https://www.googleapis.com/youtube/v3/videos"\
      "?id=#{movie_id}&key=#{Figaro.env.GG_API_KEY}&fields=items(snippet(title,description))&part=snippet"
    ).parsed_response['items'][0]['snippet'].merge('id' => movie_id)
  rescue ActiveSupport::Dependencies::Blamable, Exception => e
    code = Time.now.to_f
    Rails.logger.info('='*20)
    Rails.logger.error("#{code} - #{e.message}\n??? #{e.backtrace[0]}")
    Rails.logger.info('='*20)

    add_error(I18n.t('error.movies.failed_to_read_data_from_url'))
  end
end
