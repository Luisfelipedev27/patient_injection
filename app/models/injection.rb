class Injection < ApplicationRecord
  belongs_to :patient

  validates :dose, presence: true, numericality: { greater_than: 0 }
  validates :lot_number, presence: true, length: { is: 6 }, format: { with: /\A[A-Za-z0-9]{6}\z/ }
  validates :drug_name, presence: true
  validates :injected_at, presence: true

  scope :ordered_by_date, -> { order(:injected_at) }
end
