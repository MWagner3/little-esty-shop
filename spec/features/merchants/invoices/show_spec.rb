require "rails_helper"

RSpec.describe 'Merchant Invoices show page' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Primate Privleges')

    @item_1 = @merchant_1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 1000)
    @item_2 = @merchant_1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 2000)

    @customer_1 = Customer.create(first_name: 'Teddy', last_name: 'Wagner')

    @invoice_1 = @customer_1.invoices.create!(status: 1)
    @invoice_2 = @customer_1.invoices.create!(status: 1)

    @invoice_item_1 = @invoice_1.invoice_items.create(item_id: @item_1.id, quantity: 3, unit_price: 1000, status: 1)
    @invoice_item_2 = @invoice_2.invoice_items.create(item_id: @item_2.id, quantity: 1, unit_price: 2000, status: 1)



    visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
  end

  it "I see invoice's id, status and created_at date" do
    expect(page).to have_content("Invoice Number: #{@invoice_1.id}")
    expect(page).to_not have_content("Invoice Number: #{@invoice_2.id}")
    expect(page).to have_content("Status: #{@invoice_1.status}")
    expect(page).to have_content("Created On: #{@invoice_1.creation_date_formatted}")
  end

  it "I see customer's first and last name" do
    expect(page).to have_content("Customer Name: #{@customer_1.first_name} #{@customer_1.last_name}")
  end

  it "I see name, quantity, price and status of each item on the invoice" do
    within "#invoice_item-#{@invoice_item_1.id}" do
      expect(page).to have_content(@invoice_item_1.item.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_1.unit_price/100)
      expect(page).to have_content(@invoice_item_1.status)
      expect(page).to_not have_content(@invoice_item_2.item.name)
    end
  end

  it "Shows total revenue that will be generated from all items on the invoice" do

    expect(page).to have_content("Total Revenue: $30")
  end
end
