class Movie < ApplicationRecord
  belongs_to :shared_by, class_name: '::User'
end
