require_relative './helpers/authenticable'

class BaseApi < Grape::API
  def self.inherited(subclass)
    super

    subclass.instance_eval do
      helpers do
        def custom_json_render(data, custom_data: {})
          if data.respond_to?(:map)
            {
              data: {
                items: data,
                pageIndex: params[:page_index] || custom_data[:page_index] || 1,
                itemsPerPage: params[:items_per_page] || custom_data[:items_per_page] || data.length,
                currentItemCount: data.length,
                totalItems: data.try(:total_count) || custom_data[:total_items] || data.length,
                totalPages: data.try(:total_pages) || custom_data[:total_pages] || 1
              }
            }
          else
            { data: data }
          end
        end

        def custom_json_error(error, status = 422, custom_data: {})
          errors = error.respond_to?(:map) ? error : [error]

          res = {
            error: {
              code: status,
              errors: errors.map do |e|
                { message: e.respond_to?(:message) ? e.message : e.to_s }
              end
            }
          }

          error!(res, status)
        end

        def declared_params
          declared(params, include_missing: false)
        end
      end

      helpers ::Api::Authenticable
    end
  end
end
