class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :item_id, presence: true, numericality: true
  validates :invoice_id, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true
  validates :quantity, presence: true, numericality: true

  enum status: { pending: 0, packaged: 1, shipped: 2 }

  before_validation :integer_status
  before_save :apply_discount

  def set_discount(bulk_discount)
    self.bulk_discount_id = bulk_discount.id
    self.bulk_discount_percentage = bulk_discount.discount
    self.bulk_discount_name = bulk_discount.name
    self.unit_price = (unit_price * (1 - bulk_discount_percentage / 100.to_f))
  end

  def apply_discount
    best_discount = item.best_discount(quantity)
    set_discount(best_discount.first) if best_discount.any?
  end

  private

  def integer_status
    self.status = 0 if status == 'pending'
    self.status = 1 if status == 'packaged'
    self.status = 2 if status == 'shipped'
  end
end
