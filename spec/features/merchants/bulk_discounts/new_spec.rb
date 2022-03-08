require 'rails_helper'

RSpec.describe 'New Bulk Discount' do
  it 'will create a new bulk discount' do
    merchant = create(:merchant)
    visit(new_merchant_bulk_discount_path(merchant))
    fill_in('bulk_discount[name]', with: 'Christmas')
    fill_in('bulk_discount[discount]', with: 10)
    fill_in('bulk_discount[threshold]', with: 5)
    click_button('Create Bulk discount')
    expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    expect(page).to have_content('Christmas')
    expect(page).to have_content(10)
    expect(page).to have_content(5)
  end
end
