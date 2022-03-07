class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :bulk_discounts
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  enum status: { enabled: 0, disabled: 1 }

  validates :name, presence: true

  def self.top_merchants(count)
    joins(items: [invoice_items: [invoice: :transactions]])
      .where(transactions: { result: 0 })
      .group(:id)
      .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .order(revenue: :desc)
      .limit(count)
  end

  def favorite_customers
      transactions.joins(invoice: :customer)
                .where('result = ?', 0)
                .where("invoices.status = ?", 1)
                .select("customers.*, count('transactions.result') as top_result")
                .group('customers.id')
                .order(top_result: :desc)
                .distinct
                .limit(5)
  end                  

  def items_ready_to_ship
    item_ids = InvoiceItem.where("status = 1 OR status = 2").order(:created_at).pluck(:item_id)
    item_ids.map do |id|
      Item.find(id)
    end
  end

  def best_day
    items.joins(invoices: :transactions)
         .where(transactions: { result: 0 })
         .select('invoices.created_at')
         .group('invoices.created_at')
         .order('invoices.created_at desc')
         .limit(1)
  end
end
