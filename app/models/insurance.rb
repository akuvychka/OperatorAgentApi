class Insurance < ApplicationRecord
  INSURANCE_TYPES = ['life', 'property', 'health care'].freeze
  PERIODS = %w(monthly annual).freeze

  has_many :contracts, dependent: :destroy

  validates :agency_name, presence: true
  validates :total_cost, presence: true
  validate :validate_insurance_type
  validate :validate_period

  private

  def validate_insurance_type
    errors.add(:insurance_type, :invalid_extension) unless insurance_type.present?
    errors.add(:insurance_type, :invalid_extension) if INSURANCE_TYPES.index(insurance_type).blank?
  end

  def validate_period
    errors.add(:period, :invalid_extension) unless period.present?
    errors.add(:period, :invalid_extension) if PERIODS.index(period).blank?
  end
end
