require 'rails_helper'

RSpec.describe "Bulk Discount Show Page" do 
    before(:each) do
        @discount = create(:bulk_discount)
    end
    it 'will show the threshold quantity and percentage discount' do 
        visit(merchant_bulk_discount_url(@discount.merchant, @discount))
        expect(page).to have_content(@discount.name)
        expect(page).to have_content(@discount.quantity)
        expect(page).to have_content(@discount.discount)
    end
end