class BulkDiscount < ApplicationRecord 
    belongs_to :merchant

    validates :threshold, presence: true, numericality: {only_integer: true }
    validates :discount, presence: true, numericality: {only_float: true}
    validates :name, presence: true
    after_update :apply_bulk_discount
    after_create :apply_bulk_discount
    after_destroy :apply_bulk_discount

    def apply_bulk_discount 
        invoice_item_ids = merchant.items.joins(:invoice_items).pluck('invoice_items.id')
        invoice_items = invoice_item_ids.map {|id| InvoiceItem.find(id)}
        invoice_items.each do |invoice_item|
            invoice_item.apply_discount
            invoice_item.save
        end
    end
end