class Movie < ApplicationRecord
  belongs_to :shared_by, class_name: '::User'

  validates :url, presence: true
  validates :url, format: { with: URI.regexp }, allow_blank: true
end
