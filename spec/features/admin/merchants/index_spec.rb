require 'rails_helper'

RSpec.describe 'Admin Merchants Index' do
  describe 'user story #17' do
    it "when visiting /admin/merchants I see the name of each merchant" do
      merchant_1 = Merchant.create!(name: "LT's Tee Shirts LLC")
      merchant_2 = Merchant.create!(name: 'Handmade in CO Co.')
      merchant_3 = Merchant.create!(name: 'Moss Box Inc')

      visit "/admin/merchants"

      expect(page).to have_content("LT's Tee Shirt Wondertorium")
      expect(page).to have_content('Stickers R Us')
      expect(page).to have_content('Moss Box Exchange')
    end
  end
end
