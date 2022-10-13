module V1
  class Movies < ::BaseApi
    resource :movies do
      desc 'get list of movies'
      params do
        optional :page_index, type: Integer, default: 1
        optional :items_per_page, type: Integer, default: 20
      end

      get do
        data = movies_collection.includes(:shared_by)
        custom_json_render data, serializer: MovieSerializer
      end

      desc 'shared a new movie'
      params do
        requires :url, type: String, regexp: URI.regexp
      end
      post do
        authorize_user!

        share_movie_service = ::ShareMovie.new(shared_by: current_user, url: declared_params[:url]).tap(&:call)

        if share_movie_service.success?
          custom_json_render share_movie_service.movie, serializer: MovieSerializer
        else
          custom_json_error(share_movie_service.errors, 422)
        end
      end
    end

    helpers do
      def movies_collection
        Movie.order(id: :desc).page(declared_params[:page_index]).per(declared_params[:items_per_page])
      end
    end
  end
end
