class Collection < ApplicationRecord
  has_many :residues
  has_many :reports, dependent: :destroyreport
  has_one :notification, dependent: :destroy
  
  validates :max_value, presence: true
end
