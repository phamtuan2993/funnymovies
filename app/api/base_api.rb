class BaseApi < Grape::API
  def self.inherited(subclass)
    super

    subclass.instance_eval do
      helpers do
        def custom_json_render(data, custom_data: {})
          if data.respond_to?(:length)
            {
              data: {
                items: data,
                page_index: params[:page_index] || custom_data[:page_index] || 1,
                items_per_page: params[:items_per_page] || custom_data[:items_per_page] || data.length,
                total_items: data.try(:total_count) || custom_data[:total_items] || data.length,
                total_pages: data.try(:total_pages) || custom_data[:total_pages] || 1
              }
            }
          else
            { data: data }
          end
        end

        def declared_params
          declared(params, include_missing: false)
        end
      end
    end
  end
end
