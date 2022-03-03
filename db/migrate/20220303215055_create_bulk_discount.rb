class CreateBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :quantity
      t.float :discount
      t.string :name
      t.references :merchant, foreign_key: true
    end
  end
end
