class Residue < ApplicationRecord
  belongs_to :laboratory
  belongs_to :collection
  has_many :registers, dependent: :destroy
end
