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
end