require "rails_helper"

RSpec.describe 'Merchant Invoices Index' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Primate Privleges')

    @item_1 = @merchant_1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 1000)
    @item_2 = @merchant_1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 2000)

    @customer = Customer.create(first_name: 'Teddy', last_name: 'Wagner')

    @invoice_1 = @customer.invoices.create!(status: 1)
    @invoice_2 = @customer.invoices.create!(status: 1)

    @invoice_item_1 = @invoice_1.invoice_items.create(item_id: @item_1.id, quantity: 3, unit_price: 1000, status: 1)
    @invoice_item_2 = @invoice_1.invoice_items.create(item_id: @item_2.id, quantity: 1, unit_price: 2000, status: 1)


    visit "/merchants/#{@merchant.id}/invoices"
  end

  it "I see all the invoices that has merchant's items" do

    expect(page).to have_content("Invoice ##{@invoice_1.id}")
    expect(page).to have_content("Invoice ##{@invoice_2.id}")
  end

  it "I see invoice_id for each invoice, which links to merchant invoice show page" do
    click_on "Invoice ##{@invoice_1.id}"
    expect(current_path).to eq("/merchants/#{@merchant.id}/invoices/#{@invoice_1.id}")
  end
end
