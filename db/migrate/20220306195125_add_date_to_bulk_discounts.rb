class AddDateToBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_discounts, :date, :string, default:nil
  end
end
