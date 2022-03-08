require 'rails_helper'

RSpec.describe 'Edit Bulk Discount Page' do
  it 'will allow the discount to be edited' do
    merchant = create(:merchant, name: 'Jeff')
    discount = create(:bulk_discount, name: 'New Years', threshold: 5, discount: 20.0, merchant: merchant)
    visit(edit_merchant_bulk_discount_path(merchant.id, discount.id))
    fill_in('bulk_discount[name]', with: 'Christmas')
    fill_in('bulk_discount[discount]', with: 10)
    fill_in('bulk_discount[threshold]', with: 5)
    click_button('Update Bulk discount')
    expect(current_path).to eq(merchant_bulk_discount_path(merchant, discount))
    expect(page).to have_content('Christmas')
    expect(page).to have_content(10)
    expect(page).to have_content(5)
  end
end

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
