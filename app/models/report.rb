class Report < ApplicationRecord
  belongs_to :collection
  has_many :reportcell, dependent: :destroyrepost
end
