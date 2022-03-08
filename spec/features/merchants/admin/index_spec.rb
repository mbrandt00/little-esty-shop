require 'rails_helper'

RSpec.describe 'admin merchant index' do
  it 'displays name of each merchant in the system' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    merchant_4 = create(:merchant)

    visit '/admin/merchants'

    expect(page).to have_content(merchant_1.name)
    expect(page).to have_content(merchant_2.name)
    expect(page).to have_content(merchant_3.name)
    expect(page).to have_content(merchant_4.name)
    expect(page).to_not have_content(merchant_4.id)
  end

  describe 'Admin Merchant Enable/Disable' do
    it 'disabled merchants can be enabled with button click' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      merchant_4 = create(:merchant, status: 1)

      visit '/admin/merchants/'

      within('.enabled') do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_3.name)
        expect(page).to_not have_content(merchant_4.name)
        expect(page).to have_button('Disable', count: 3)
      end
      within('.disabled') do
        expect(page).to have_content(merchant_4.name)
        expect(page).to have_button('Enable', count: 1)
      end

      click_button('Enable')
      expect(current_path).to eq('/admin/merchants/')

      within('.enabled') do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_3.name)
        expect(page).to have_content(merchant_4.name)
        expect(page).to have_button('Disable', count: 4)
      end
      within('.disabled') do
        expect(page).to_not have_content(merchant_4.name)
      end
    end
    it 'enabled merchants can be DISABLED with button click' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant, status: 1)
      merchant_3 = create(:merchant, status: 1)
      merchant_4 = create(:merchant, status: 1)

      visit '/admin/merchants/'

      within('.enabled') do
        expect(page).to have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_4.name)
        expect(page).to have_button('Disable', count: 1)
      end
      within('.disabled') do
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_3.name)
        expect(page).to have_content(merchant_4.name)
        expect(page).to have_button('Enable', count: 3)
      end

      click_button('Disable')
      expect(current_path).to eq('/admin/merchants/')

      within('.enabled') do
        expect(page).to_not have_content(merchant_1.name)
      end
      within('.disabled') do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_3.name)
        expect(page).to have_content(merchant_4.name)
        expect(page).to have_button('Enable', count: 4)
      end
    end
  end

  it 'Admin Merchants Grouped by Status' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    merchant_4 = create(:merchant, status: 1)

    visit '/admin/merchants/'

    within '.enabled' do
      expect(page).to have_content(merchant_1.name)
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
      expect(page).to have_button('Disable', count: 3)
    end

    within '.disabled' do
      expect(page).to have_content(merchant_4.name)
      expect(page).to have_button('Enable', count: 1)
    end

    click_button('Enable')
    expect(current_path).to eq('/admin/merchants/')

    within '.enabled' do
      expect(page).to have_content(merchant_1.name)
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
      expect(page).to have_content(merchant_4.name)
      expect(page).to have_button('Disable', count: 4)
    end

    within '.disabled' do
      expect(page).to_not have_content(merchant_4.name)
      expect(page).to_not have_button('Enable', count: 1)
    end
  end

  it 'Admin Merchant Create' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    merchant_4 = create(:merchant, status: 1)

    visit '/admin/merchants/'

    expect(page).to have_link('New Merchant')
    expect(page).to_not have_content('Arch City Apparel')
    click_link('New Merchant')
    expect(current_path).to eq('/admin/merchants/new')

    fill_in 'name', with: 'Arch City Apparel'
    click_button('Submit')
    expect(current_path).to eq('/admin/merchants/')

    within '.disabled' do
      expect(page).to have_content('Arch City Apparel')
      expect(page).to have_content(merchant_4.name)
      expect(page).to have_button('Enable', count: 2)
      expect(page).to_not have_content(merchant_1.name)
    end
  end
end
