require "rails_helper"

RSpec.describe 'Merchant Invoices Index' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Primate Privleges')
    @merchant_2 = Merchant.create!(name: 'Sandras Affairs')

    @item_1 = @merchant_1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 1000)
    @item_2 = @merchant_1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 2000)
    @item_3 = @merchant_2.items.create!(name: 'Rodrigo Rippers', description: 'IYKYK', unit_price: 900)

    @customer_1 = Customer.create(first_name: 'Teddy', last_name: 'Wagner')
    @customer_2 = Customer.create(first_name: 'Alice', last_name: 'Wagner')

    @invoice_1 = @customer_1.invoices.create!(status: 1)
    @invoice_2 = @customer_1.invoices.create!(status: 1)
    @invoice_3 = @customer_2.invoices.create!(status: 1)

    @invoice_item_1 = @invoice_1.invoice_items.create(item_id: @item_1.id, quantity: 3, unit_price: 1000, status: 1)
    @invoice_item_2 = @invoice_2.invoice_items.create(item_id: @item_2.id, quantity: 1, unit_price: 2000, status: 1)
    @invoice_item_3 = @invoice_3.invoice_items.create(item_id: @item_3.id, quantity: 2, unit_price: 3000, status: 1)


    visit "/merchants/#{@merchant_1.id}/invoices"
  end

  it "I see all the invoices that has merchant's items" do
    expect(page).to have_content("Invoice ##{@invoice_1.id}")
    expect(page).to have_content("Invoice ##{@invoice_2.id}")
    expect(page).to_not have_content("Invoice ##{@invoice_3.id}")
  end

  it "I see invoice_id for each invoice, which links to merchant invoice show page" do
    click_on "#{@invoice_1.id}"
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
  end
end
