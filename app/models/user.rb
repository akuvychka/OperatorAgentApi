class User < ApplicationRecord
  ROLES = %w[operator agent].freeze

  has_many :contracts, dependent: :destroy
  has_many :companions, dependent: :destroy
  has_many :contacts, through: :companions

  validates :email, presence: true, uniqueness: true
  validate :validate_role

  def is?(role)
    user_role == role.to_s
  end

  private

  def validate_role
    errors.add(:user_role, :invalid_extension) unless user_role.present?
    errors.add(:user_role, :invalid_extension) if ROLES.index(user_role).blank?
  end
end
