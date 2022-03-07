class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :transactions
  validates :customer_id, presence: true
  validates :status, presence: true

  enum status: { 'in progress' => 0, completed: 1, cancelled: 2 }

  before_validation :integer_status

  def created_at_date
    created_at.strftime('%A, %B %d, %Y')
  end

  def total_revenue_including_discounts
    invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def total_revenue_excluding_discounts 
    invoice_items.joins(:item).group(:id).sum('items.unit_price * invoice_items.quantity').sum{|h,k| k}
  end

  def self.incomplete_invoices
    joins(:invoice_items)
      .where(invoice_items: { status: [0, 1] })
      .select('invoices.*, COUNT(invoice_items.id)')
      .group(:id)
      .order('invoices.created_at')
  end

    def change_status(result)
    self.status = 0 if result == 'in progress'
    completed! if result == 'completed'
    cancelled! if result == 'cancelled'
  end

  private

  def integer_status
    self.status = 0 if status == 'in progress'
    self.status = 1 if status == 'completed'
    self.status = 2 if status == 'cancelled'
  end
end
