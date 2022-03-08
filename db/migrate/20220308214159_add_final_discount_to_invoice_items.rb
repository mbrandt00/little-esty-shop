class AddFinalDiscountToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :final_discount_percentage, :integer, default:nil
  end
end
