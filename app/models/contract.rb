class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :insurance
  belongs_to :client

  validate :user_type
  validates :insurance, presence: true
  validates :client, presence: true

  private

  def user_type
    errors.add(:user, "Agent can't be blank") unless user.present?
    errors.add(:user, 'Incorrect user. User have to be agent') if user.user_role != 'agent'
  end
end
