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
  def change_status(result)
    pending! if result == 'pending'
    packaged! if result == 'packaged'
    shipped! if result == 'shipped'
  end

  def set_discount(bulk_discount)
    self.bulk_discount_id = bulk_discount.id
    self.bulk_discount_percentage = bulk_discount.discount
    self.bulk_discount_name = bulk_discount.name
  end

  def apply_discount
    best_discount = item.best_discount(quantity)
    if best_discount.any?
      set_discount(best_discount.first)
      self.unit_price = (self.unit_price * (1- bulk_discount_percentage/100.to_f))
    end
  end

  def amount_saved
    (item.unit_price - self.unit_price) * quantity
  end
  
  private

  def integer_status
    self.status = 0 if status == 'pending'
    self.status = 1 if status == 'packaged'
    self.status = 2 if status == 'shipped'
  end
end
