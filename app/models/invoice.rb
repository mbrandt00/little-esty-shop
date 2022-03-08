class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :transactions
  validates :customer_id, presence: true
  validates :status, presence: true

  enum status: { inprogress: 0, completed: 1, cancelled: 2 }

  before_validation :integer_status
  after_save :record_discount

  def created_at_date
    created_at.strftime('%A, %B %d, %Y')
  end

  def total_revenue_including_discounts
    invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def total_revenue_excluding_discounts
    invoice_items.joins(:item).group(:id).sum('items.unit_price * invoice_items.quantity').sum { |_h, k| k }
  end

  def self.incomplete_invoices
    joins(:invoice_items)
      .where(invoice_items: { status: [0, 1] })
      .select('invoices.*, COUNT(invoice_items.id)')
      .group(:id)
      .order('invoices.created_at')
  end

  def self.pending_with_discount(discount)
    joins(:invoice_items)
      .where('invoice_items.bulk_discount_id = ?', discount.id)
      .where(status: 0)
  end

  def change_status(result)
    inprogress! if result == 'inprogress'
    completed! if result == 'completed'
    cancelled! if result == 'cancelled'
  end

  private

  def integer_status
    self.status = 0 if status == 'in progress'
    self.status = 1 if status == 'completed'
    self.status = 2 if status == 'cancelled'
  end

  def record_discount
    if completed?
      invoice_items.each do |invoice_item|
        invoice_item.final_discount_percentage = invoice_item.bulk_discount_percentage
      end
    end
  end
end
