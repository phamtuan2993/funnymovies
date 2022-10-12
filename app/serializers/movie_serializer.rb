class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :embedded_id, :url

  belongs_to :shared_by, serializer: UserSerializer
end
