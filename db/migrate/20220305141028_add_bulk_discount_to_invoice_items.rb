class AddBulkDiscountToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :bulk_discount_id, :integer
    add_column :invoice_items, :bulk_discount_percentage, :integer, default:0
    add_column :invoice_items, :bulk_discount_name, :string
  end
end
