class Patient < ApplicationRecord
  has_many :injections, dependent: :destroy

  validates :api_key, presence: true, uniqueness: true
  validates :treatment_schedule_days, presence: true, numericality: { greater_than: 0 }

  before_validation :generate_api_key, on: :create

  private

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
