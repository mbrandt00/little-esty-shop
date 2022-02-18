class Transaction < ApplicationRecord
  belongs_to :invoice
  validates :credit_card_number, presence: true, numericality: true
  validates :credit_card_expiration_date, presence: true
  validates :result, presence: true, numericality: true
  validates :invoice_id, presence: true, numericality: true

end