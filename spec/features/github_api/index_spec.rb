require 'rails_helper'

RSpec.describe 'github api index' do
  it 'displays name of project repository' do
    visit '/github_api/'
    expect(page).to have_content('mbrandt00/little-esty-shop')
  end

  it 'displays usernames of all users with 1 or more commits' do
    visit '/github_api/'

    within('#contributors') do
      expect(page).to have_content('mbrandt00')
    end
  end

  it 'displays the total count of Pull Requests for repo' do
    visit '/github_api/'

    expect(page).to have_content('Pull Requests:')
  end
end
