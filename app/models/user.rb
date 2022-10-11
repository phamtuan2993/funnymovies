class User < ApplicationRecord
  include DatabaseAuthenticable

  has_many :movies, foreign_key: :shared_by_id, inverse_of: :shared_by
end
