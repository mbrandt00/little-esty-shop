require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :customer_id }
    it { should validate_presence_of :status }
  end
  describe 'relationships' do
    it { should have_many :invoice_items }
    it { should have_many :transactions }
    it { should belong_to :customer }
  end

  describe 'instance methods' do
    describe '.created_at_date' do
      it 'can reformat the created_at timestamp' do
        invoice_1 = create(:invoice, created_at: Time.parse('2022-02-22'))
        expect(invoice_1.created_at_date).to eq('Tuesday, February 22, 2022')
      end
    end

    describe 'revenues' do
      before :each do
        @merchant = create(:merchant)
        @invoice = create(:invoice)
        @bulk_discount_1 = create(:bulk_discount, threshold: 5, discount: 10, name: 'small discount',
                                                  merchant: @merchant)
        @bulk_discount_2 = create(:bulk_discount, threshold: 15, discount: 20, name: 'large discount',
                                                  merchant: @merchant)
        @item_1 = create(:item, name: 'Cupcake', merchant: @merchant, unit_price: 10)
        @item_2 = create(:item, name: 'Cake', merchant: @merchant, unit_price: 10)
        @invoice_item_1 = create(:invoice_item, unit_price: 10, quantity: 5, status: 'pending', item: @item_1,
                                                invoice: @invoice)
        @invoice_item_2 = create(:invoice_item, unit_price: 10, quantity: 1, status: 'pending', item: @item_2,
                                                invoice: @invoice)
        @invoice_item_3 = create(:invoice_item, unit_price: 10, quantity: 30, status: 'pending', item: @item_2,
                                                invoice: @invoice)
      end
      it 'can calculate the total revenue of each invoice including discounts' do
        expect(@invoice.total_revenue_including_discounts).to eq(295)
      end
      it 'can calculate the total revenue excluding discounts' do
        expect(@invoice.total_revenue_excluding_discounts).to eq(360)
      end
    end
  end
  describe 'class methods' do
    it '#incomplete_invoices' do
      invoice_1 = create(:invoice)
      invoice_item_1 = create(:invoice_item, status: 'pending', invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, status: 'shipped', invoice_id: invoice_1.id)
      invoice_item_3 = create(:invoice_item, status: 'packaged', invoice_id: invoice_1.id)
      invoice_2 = create(:invoice)
      invoice_item_4 = create(:invoice_item, status: 'shipped', invoice_id: invoice_2.id)
      invoice_item_5 = create(:invoice_item, status: 'shipped', invoice_id: invoice_2.id)
      invoice_item_6 = create(:invoice_item, status: 'shipped', invoice_id: invoice_2.id)
      invoice_3 = create(:invoice)
      invoice_item_7 = create(:invoice_item, status: 'packaged', invoice_id: invoice_3.id)
      invoice_item_8 = create(:invoice_item, status: 'packaged', invoice_id: invoice_3.id)
      invoice_item_9 = create(:invoice_item, status: 'packaged', invoice_id: invoice_3.id)
      incomplete = Invoice.incomplete_invoices
      expect(incomplete.length).to eq(2)
      expect(incomplete.first).to eq(invoice_1)
      expect(incomplete.second).to eq(invoice_3)
    end

    it 'can order incomplete_invoices oldest to newest' do
      invoice_1 = create(:invoice, created_at: '2012-03-07 14:54:15 UTC')
      invoice_item_1 = create(:invoice_item, status: 'pending', invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, status: 'shipped', invoice_id: invoice_1.id)
      invoice_item_3 = create(:invoice_item, status: 'packaged', invoice_id: invoice_1.id)
      invoice_2 = create(:invoice, created_at: '2012-03-06 00:54:24 UTC')
      invoice_item_7 = create(:invoice_item, status: 'packaged', invoice_id: invoice_2.id)
      invoice_item_8 = create(:invoice_item, status: 'packaged', invoice_id: invoice_2.id)
      invoice_item_9 = create(:invoice_item, status: 'packaged', invoice_id: invoice_2.id)
      incomplete = Invoice.incomplete_invoices
      expect(incomplete.first).to eq(invoice_2)
      expect(incomplete.second).to eq(invoice_1)
    end
  end
end
