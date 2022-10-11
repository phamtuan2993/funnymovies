module V1
  class Movies < ::BaseApi
    resource :movies do
      desc 'get list of movies'
      params do
        optional :page_index, type: Integer, default: 1
        optional :items_per_page, type: Integer, default: 20
      end

      get do
        custom_json_render movies_collection
      end
    end

    helpers do
      def movies_collection
        Movie.order(id: :asc).page(declared_params[:page_index]).per(declared_params[:items_per_page])
      end
    end
  end
end
