require 'rails_helper'

RSpec.describe 'Merchant Items Show page' do
  describe '#user story #34' do
    it 'displays the item attributes' do
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      visit "/merchants/#{merchant1.id}/items"

      click_on item1.name
      expect(page).to have_content(item1.name)
      expect(page).to have_content(item1.description)
      expect(page).to have_content(item1.unit_price)
    end
  end

  describe '#user story 33' do
    it 'allows the merchant to update their items' do
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      visit "/merchants/#{merchant1.id}/items/#{item1.id}"
      expect(page).to have_link("Update #{item1.name}")
      click_on("Update #{item1.name}")
      expect(current_path).to eq("/merchants/#{merchant1.id}/items/#{item1.id}/edit")
      expect(page).to have_field(:item_name, with: 'Monkey Paw')
      expect(page).to have_field(:item_description, with: 'A furry mystery')
      expect(page).to have_field(:item_unit_price, with: 3)

      within('#item_update') do
        fill_in 'item_unit_price', with: 23
        click_on 'Update Item'
      end
      expect(current_path).to eq("/merchants/#{merchant1.id}/items/#{item1.id}")
      expect(page).to have_content('Item Successfully Updated')
    end
  end

  describe 'user story 37' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: 'Bosco, Howe and Davis')

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Osinski')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Toy')
      @customer_4 = Customer.create!(first_name: 'Leanne', last_name: 'Braun')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 1)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 1)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 1)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

      @item_1 = Item.create!(name: "Qui Esse", description: "Nihil autem sit odio inventore deleniti", unit_price: 15, merchant_id: @merchant_1.id)
      @item_2 = Item.create!(name: "Autem Minima", description: "Cumque consequuntur ad", unit_price: 10, merchant_id: @merchant_1.id)
      @item_3 = Item.create!(name: "Ea Voluptatum", description: "Sunt officia eum qui molestiae", unit_price: 8, merchant_id: @merchant_1.id)
      @item_4 = Item.create!(name: "Nemo Facere", description: "Sunt eum id eius magni consequuntur delectus veritatis", unit_price: 2, merchant_id: @merchant_1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 15, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 8, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 8, status: 1)
      @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 8, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 2, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 10, status: 1)

      @transaction_1 = Transaction.create!(credit_card_number: 4654405418249632, result: 1, invoice_id: @invoice_1.id)
      @transaction_2 = Transaction.create!(credit_card_number: 4580251236515201, result: 1, invoice_id: @invoice_3.id)
      @transaction_3 = Transaction.create!(credit_card_number: 4354495077693036, result: 1, invoice_id: @invoice_4.id)
      @transaction_4 = Transaction.create!(credit_card_number: 4515551623735607, result: 1, invoice_id: @invoice_5.id)
      @transaction_5 = Transaction.create!(credit_card_number: 4844518708741275, result: 1, invoice_id: @invoice_6.id)
      @transaction_6 = Transaction.create!(credit_card_number: 4203696133194408, result: 1, invoice_id: @invoice_7.id)
      @transaction_7 = Transaction.create!(credit_card_number: 4801647818676136, result: 1, invoice_id: @invoice_2.id)

      visit "/merchants/#{@merchant_1.id}/dashboard"
    end

    it "shows ordered item names yet to be shipped + invoice id links tethered to each item" do
      visit "/merchants/#{@merchant_1.id}/dashboard"

      within ".items-ready-to-ship" do
        expect(page).to have_content(@item_1.name)
        # expect(page).to_not have_link("Order number: #{@invoice_1.id}")
        expect(page).to have_link("Order number: #{@invoice_2.id}")
        expect(page).to have_link("Order number: #{@invoice_3.id}")
        # expect(page).to_not have_link("Order number: #{@invoice_4.id}")
        expect(page).to have_link("Order number: #{@invoice_5.id}")
        expect(page).to have_link("Order number: #{@invoice_6.id}")
        # expect(page).to_not have_link("Order number: #{@invoice_7.id}")
        expect(page).to have_link("Order number: #{@invoice_8.id}")
        expect(page).to have_link("Order number: #{@invoice_9.id}")
        # expect(page).to_not have_link("Order number: #{@invoice_10.id}")
        expect(page).to have_link("Order number: #{@invoice_11.id}")
        expect(page).to have_link("Order number: #{@invoice_12.id}")
      end
    end
  end
end
