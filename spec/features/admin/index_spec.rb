require 'rails_helper'

RSpec.describe 'Admin Index' do
  it 'has a header that lets the user know they are on the admin dashboard' do

    visit '/admin'

    expect(page).to have_content('Admin Dashboard')
  end

  it 'shows links to admin merchants index' do
    visit '/admin'

    expect(page).to have_link("Admin Merchants Index")
    click_link "Admin Merchants Index"
    expect(current_path).to eq(admin_merchants_path)
  end

  it 'shows links to admin invoices index' do
    visit '/admin'

    expect(page).to have_link("Admin Invoices Index")
    click_link "Admin Invoices Index"
    expect(current_path).to eq(admin_invoices_path)
  end
end
