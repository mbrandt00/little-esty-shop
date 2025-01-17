require 'rails_helper'

RSpec.describe 'merchants invoices show page' do
  it 'displays information and attributes of an invoice' do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    item_1 = create(:item, merchant_id: merchant_1.id)
    invoice_1 = create(:invoice, customer_id: customer_1.id)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id)

    merchant_2 = create(:merchant)
    customer_2 = create(:customer)
    item_2 = create(:item, merchant_id: merchant_2.id)
    invoice_2 = create(:invoice, customer_id: customer_2.id)
    invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id)

    visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"
    expect(page).to have_content("Invoice ##{invoice_1.id}")
    expect(page).to have_content(invoice_1.id)
    expect(page).to have_content(invoice_1.status)
    expect(page).to have_content(invoice_1.created_at_date)
    expect(page).to have_content(customer_1.first_name)
    expect(page).to have_content(customer_1.last_name)

    visit "/merchants/#{merchant_2.id}/invoices/#{invoice_2.id}"

    expect(page).to have_content(invoice_2.id)
    expect(page).to have_content(invoice_2.status)
    expect(page).to have_content(invoice_2.created_at_date)
    expect(page).to have_content(customer_2.first_name)
    expect(page).to have_content(customer_2.last_name)
  end

  it 'displays information for items sold' do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    item_1 = create(:item, merchant_id: merchant_1.id)
    invoice_1 = create(:invoice, customer_id: customer_1.id)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id)

    item_2 = create(:item, merchant_id: merchant_1.id)
    invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_1.id)

    item_3 = create(:item, merchant_id: merchant_1.id)
    invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_1.id)

    visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"
    expect(page).to have_content("Invoice ##{invoice_1.id}")
    expect(page).to have_content(item_1.name)
    expect(page).to have_content(invoice_item_1.quantity)
    expect(page).to have_content(item_1.unit_price)
    expect(page).to have_content(invoice_item_1.status)
  end

  it 'shows each invoice item status is a select field where current status is selected' do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    item_1 = create(:item, merchant_id: merchant_1.id)
    invoice_1 = create(:invoice, customer_id: customer_1.id)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id)

    item_2 = create(:item, merchant_id: merchant_1.id)
    invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_1.id)

    item_3 = create(:item, merchant_id: merchant_1.id)
    invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_1.id)

    visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

    within("##{invoice_item_1.id}") do
      select invoice_item_1.status.to_s
      select('packaged')
      expect(page).to have_button('Update Item Status')

      click_button 'Update Item Status'
      expect(page).to have_select(selected: 'packaged')
      expect(page).to_not have_select(selected: 'shipped')
      expect(page).to_not have_select(selected: 'pending')
    end

    within("##{invoice_item_2.id}") do
      select invoice_item_2.status.to_s
      select('pending')
      expect(page).to have_button('Update Item Status')

      click_button 'Update Item Status'
      expect(page).to have_select(selected: 'pending')
      expect(page).to_not have_select(selected: 'shipped')
      expect(page).to_not have_select(selected: 'packaged')
    end

    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}")
  end
  it 'will have links to the bulk discount if applicable' do
    merchant_1 = create(:merchant)
    bulk_discount = create(:bulk_discount, name: 'test', threshold: 5, discount: 10, merchant: merchant_1)
    customer_1 = create(:customer)
    item_1 = create(:item, merchant_id: merchant_1.id)
    invoice_1 = create(:invoice, customer_id: customer_1.id)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, quantity: 15)
    visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"
    within "##{invoice_item_1.id}" do
      expect(page).to have_link('10% Discount')
      click_link('10% Discount')
      expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bulk_discount))
    end
  end
  it 'can change the status of an invoice' do 
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant_id: merchant_1.id)
    invoice_1 = create(:invoice)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, quantity: 15, status: 'pending')
    visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"
    within "##{invoice_item_1.id}" do 
      expect(page).to have_select(:status)
      select "packaged", from: :status
      click_button("Update Item Status")
      expect(page).to have_select(:status, selected: 'packaged')
      select "shipped", from: :status
      click_button("Update Item Status")
      expect(page).to have_select(:status, selected: 'shipped')
    end
  end
end
