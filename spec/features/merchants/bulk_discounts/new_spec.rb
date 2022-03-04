require 'rails_helper'

RSpec.describe 'New Bulk Discount' do 
    it 'will do something' do 
        merchant = create(:merchant)
        visit(new_merchant_bulk_discount_path(merchant))
        fill_in 'name', with: 'Christmas'
        fill_in("discount", with: 10)
        fill_in("quantity", with: 5)
        click_button('Save')
        expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    end
end