class Laboratory < ApplicationRecord
  belongs_to :department
  belongs_to :user
  has_many :residues, dependent: :destroy
  has_one :request, dependent: :destroy
  
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
