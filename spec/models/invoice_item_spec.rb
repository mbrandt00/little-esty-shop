require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
    it { should validate_presence_of :quantity }

    it { should validate_numericality_of :item_id }
    it { should validate_numericality_of :invoice_id }
    it { should validate_numericality_of :unit_price }
    it { should validate_numericality_of :quantity }
  end

  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'instance methods' do
    describe 'change_status(result)' do
      it 'can change status of invoice item' do
        invoice_item_1 = create(:invoice_item, status: 'pending')
        expect(invoice_item_1.status).to eq('pending')
        invoice_item_1.change_status('packaged')
        expect(invoice_item_1.status).to eq('packaged')
      end
    end
    describe 'bulk discounts' do 
      before :each do 
        @merchant = create(:merchant)
        @bulk_discount_1 = create(:bulk_discount, threshold: 5, discount: 10, name: 'small discount', merchant: @merchant)
        @bulk_discount_2 = create(:bulk_discount, threshold: 15, discount: 20, name: 'large discount', merchant: @merchant)
        @item_1 = create(:item, name: 'Cupcake', merchant: @merchant)
        @item_2 = create(:item, name: 'Cake', merchant: @merchant)
        @invoice_item_1 = create(:invoice_item, unit_price: 10, quantity: 5, status: 'pending', item: @item_1)
        @invoice_item_2 = create(:invoice_item, unit_price: 10, quantity: 1, status: 'pending', item: @item_2)
        @invoice_item_3 = create(:invoice_item, unit_price: 10, quantity: 30, status: 'pending', item: @item_2)
      end
      it 'will add a discount to an invoice_item' do
        @invoice_item_1.set_discount(@bulk_discount_1)
        expect(@invoice_item_1.bulk_discount_id).to eq(@bulk_discount_1.id)
        expect(@invoice_item_1.bulk_discount_name).to eq(@bulk_discount_1.name)
        expect(@invoice_item_1.bulk_discount_percentage).to eq(@bulk_discount_1.discount)
      end
      it 'will add the best discount to each invoice item' do
        expect(@invoice_item_1.unit_price).to eq(9.0)
      end
      it 'wont change the unit price if there is no applicable bulk discount' do 
        expect(@invoice_item_2.unit_price).to eq(10)
      end
      it 'will apply the best discount avaliable' do 
        expect(@invoice_item_3.unit_price).to eq(8)
      end
    end
  end
end