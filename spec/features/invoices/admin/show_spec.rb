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
    expect(page).to have_content(number_to_currency(@invoice.total_revenue_excluding_discounts))
  end
  describe "change item on invoice's status" do
    it 'will have a dropdown to update item status' do
      visit(admin_invoice_url(@invoice.id))
      within "#invoice-item-#{@invoice_item_1.id}" do
        expect(page).to have_select(:status, options: ['pending', 'packaged', 'shipped', 'Update Status'])
      end
    end
  end
  describe 'bulk discounts' do
    before :each do 
      @merchant = create(:merchant)
      @bulk_discount_1 = create(:bulk_discount, threshold: 5, discount: 10, name: 'discount a', merchant: @merchant)
      @bulk_discount_2 = create(:bulk_discount, threshold: 15, discount: 20, name: 'discount b', merchant: @merchant)

      @item_1 = create(:item, name: 'Yo-yo', merchant: @merchant, unit_price: 10)
      @item_2 = create(:item, name: 'Diablo', merchant: @merchant, unit_price: 10)
      @invoice = create(:invoice)
      @small_invoice_item = create(:invoice_item, quantity: 5, unit_price: 10, invoice: @invoice, item: @item_2)
      @large_invoice_item = create(:invoice_item, quantity: 20, unit_price: 10, invoice: @invoice, item: @item_1)
    end
    it 'will have a link to the bulk discount applied to an invoice item' do 
      visit(admin_invoice_url(@invoice))
      within "#invoice-item-#{@small_invoice_item.id}" do
        expect(page).to have_link("discount a Discount Page")
        click_link("discount a Discount Page")
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount_1))
      end
    end
    it 'will list show revenue with the discount' do 
      visit(admin_invoice_url(@invoice))
      expect(page).to have_content(number_to_currency(@invoice.total_revenue_including_discounts))
    end
    it 'will show the amount saved per item' do 
        visit(admin_invoice_url(@invoice))
        within "#invoice-item-#{@small_invoice_item.id}" do 
          expect(page).to have_content("Amount Saved: #{number_to_currency(@small_invoice_item.amount_saved)}")
        end
        within "#invoice-item-#{@large_invoice_item.id}" do 
          expect(page).to have_content("Amount Saved: #{number_to_currency(@large_invoice_item.amount_saved)}")
        end
    end
  end
end