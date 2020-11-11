class Client < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  has_many :contracts, dependent: :destroy
end
