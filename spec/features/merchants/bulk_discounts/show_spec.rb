require 'rails_helper'

RSpec.describe "Bulk Discount Show Page" do 
    before(:each) do
        @merchant = create(:merchant)
        @discount = create(:bulk_discount, merchant: @merchant)
    end
    it 'will show the threshold quantity and percentage discount' do 
        visit(merchant_bulk_discount_url(@merchant, @discount))
        expect(page).to have_content(@discount.name)
        expect(page).to have_content(@discount.threshold)
        expect(page).to have_content(@discount.discount)
    end
    it 'will have a link to edit the bulk discount' do 
        visit(merchant_bulk_discount_url(@merchant, @discount))
        expect(page).to have_link("Edit Bulk Discount")
        click_link("Edit Bulk Discount")
        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
    end
end