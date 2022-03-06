require 'rails_helper'

RSpec.describe 'Bulk Discounts index page' do 
    before :each do 
        @merchant = create(:merchant)
    end
    it 'will have an upcoming holidays section' do
        visit(merchant_bulk_discounts_url(@merchant))
        expect(page).to have_content("Upcoming Holidays")
    end
    it 'will list the next three holidays' do 
        visit(merchant_bulk_discounts_url(@merchant))
        3.times do |index|
            within "#holiday-#{index}" do 
                expect(page).to have_content("Date")
            end
        end
    end
    it 'will have a link to create a new bulk discount' do 
        visit(merchant_bulk_discounts_url(@merchant))
        expect(page).to have_link("Create Bulk Discount")
        click_link("Create Bulk Discount")
        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    end
    it 'can delete a bulk discount' do 
        bulk_discount_1 = create(:bulk_discount, merchant: @merchant)
        bulk_discount_2 = create(:bulk_discount, merchant: @merchant)
        visit(merchant_bulk_discounts_url(@merchant))
        within "#discount-0" do
            expect(page).to have_content(bulk_discount_1.name)
            click_button("Delete Discount")
            expect(page).to_not have_content(bulk_discount_1.name)
       end
    end
    describe 'creating bulk discount from holiday' do 
        it 'will have a button to create a bulk discount' do 
            visit(merchant_bulk_discounts_url(@merchant))
            within "#holiday-0" do 
                expect(page).to have_link("Create Discount")
                click_link("Create Discount")
                expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
            end
        end
        it 'will prepopulate with the required info' do 
            visit(merchant_bulk_discounts_url(@merchant))
            within "#holiday-0" do 
                expect(page).to have_link("Create Discount")
                click_link("Create Discount")
            end
            expect(page).to have_field('bulk_discount[discount]', with: 30)
            expect(page).to have_field('bulk_discount[threshold]', with: 2)
            expect(page).to have_field('bulk_discount[name]', with: 'discount')
        end
        it 'fields can be changed' do 
            visit(merchant_bulk_discounts_url(@merchant))
            within "#holiday-0" do 
                expect(page).to have_link("Create Discount")
                click_link("Create Discount")
            end
            fill_in 'bulk_discount[threshold]', with: 5
            click_button("Create Bulk discount")
            save_and_open_page
            expect(page).to have_content(5)


        end
    end
end

