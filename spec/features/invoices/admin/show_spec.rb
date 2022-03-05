require 'rails_helper'
include ActionView::Helpers::NumberHelper
RSpec.describe 'Admin Invoices Show Page' do
  before(:each) do
    @invoice = create(:invoice)
    @invoice_item_1 = create(:invoice_item, invoice_id: @invoice.id)
    @invoice_item_2 = create(:invoice_item, invoice_id: @invoice.id)
  end
  it 'will have the invoice information on the page' do
    visit(admin_invoice_url(@invoice.id))
    expect(page).to have_content(@invoice.id)
    expect(page).to have_content(@invoice.status)
    expect(page).to have_content(date_formatter(@invoice.created_at))
    expect(page).to have_content(@invoice.customer.first_name)
    expect(page).to have_content(@invoice.customer.last_name)
  end
  it 'will have invoice item information (item name, quantity, price invoice item status' do
    visit(admin_invoice_url(@invoice.id))
    expect(page).to have_content(@invoice_item_1.item.name)
    expect(page).to have_content(@invoice_item_1.quantity)
    expect(page).to have_content(@invoice_item_1.unit_price)
    expect(page).to have_content(@invoice_item_2.item.name)
    expect(page).to have_content(@invoice_item_2.quantity)
    expect(page).to have_content(@invoice_item_2.unit_price)
  end
  it 'will show the total revenue generated from the invoice' do
    visit(admin_invoice_url(@invoice.id))
    expect(page).to have_content(number_to_currency(@invoice.total_revenue))
  end
  describe "change item on invoice's status" do
    it 'will have a dropdown to update item status' do
      visit(admin_invoice_url(@invoice.id))
      within "##{@invoice_item_1.id}" do
        expect(page).to have_select(:status, options: ['pending', 'packaged', 'shipped', 'Update Status'])
      end
    end
    it 'will update the status of an item' do
      visit(admin_invoice_url(@invoice.id))
      within "##{@invoice_item_1.id}" do
        select('shipped')
        click_on('Update')
      end
      expect(current_path).to eq("/admin/invoices/#{@invoice.id}/")
      within "#invoice-item-#{@invoice_item_1.id}" do
        expect(page).to have_content('shipped')
      end
    end
  end
  describe 'bulk discounts' do 
    it 'will recognize if there should be a bulk discount for the order' do 
      merchant = create(:merchant, name: 'Jeff')
      item_1 = create(:item, name: 'Yo-yo', merchant: merchant)
      item_2 = create(:item, name: 'Diablo', merchant: merchant)
      invoice = create(:invoice)
      large_items = create(:invoice_item, quantity: 20, unit_price: 10, invoice: invoice, item_id: item_1.id)
      small_items = create(:invoice_item, quantity: 5, unit_price: 10, invoice: invoice, item_id: item_2.id)
      bulk_discount = merchant.bulk_discounts.create(threshold: 15, discount: 10, name: 'discount a')
      #binding.pry
      
    end
  end
end

# As a merchant
# When I visit my merchant invoice show page
# Then I see the total revenue for my merchant from this invoice (not including discounts)
# And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation