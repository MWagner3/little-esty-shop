require 'rails_helper'

RSpec.describe 'Merchant Items Index page' do
  describe '#User story 35' do
    it 'shows a list of all the items of one merchant' do
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      merchant2 = Merchant.create!(name: 'Sandras Affairs')
      item1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)
      item3 = merchant2.items.create!(name: 'Rodrigo Rippers', description: 'IYKYK', unit_price: 900)

      visit "/merchants/#{merchant1.id}/items"
      expect(page).to have_content('Monkey Paw')
      expect(page).to have_content('Gorilla Grip Glue')
      expect(page).to_not have_content('Rodrigo Rippers')
    end
  end

  describe '#User story #32' do
    it 'can enable an item' do
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)

      visit "/merchants/#{merchant1.id}/items"

      within("div.item_#{item1.id}") do
        expect(page).to have_button("Disable #{item1.name}")
        click_button("Disable #{item1.name}")

        expect(current_path).to eq("/merchants/#{merchant1.id}/items")

        expect(page).to have_button("Enable #{item1.name}")
        item1.reload
        expect(item1.status).to eq('disabled')
      end
    end

    it 'can disable an item' do
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)

      visit "/merchants/#{merchant1.id}/items"

      within("div.item_#{item1.id}") do
        click_button("Disable #{item1.name}")
        expect(page).to have_button("Enable #{item1.name}")
        click_button("Enable #{item1.name}")

        expect(current_path).to eq("/merchants/#{merchant1.id}/items")

        expect(page).to have_button("Disable #{item1.name}")
        item1.reload
        expect(item1.status).to eq('enabled')
      end
    end
  end

  describe '#User story #31' do
    it 'seperates enabled and disabled items' do
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7,
                                      status: 1)

      visit "/merchants/#{merchant1.id}/items"
      expect(page).to have_content('Enabled Items')
      expect(page).to have_content('Disabled Items')
      expect('Disabled Items').to appear_before(item2.name)
      expect('Enabled Items').to appear_before(item1.name)
    end
  end
  describe '#User story #30' do
    it 'can create a new item' do
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)
      visit "/merchants/#{merchant1.id}/items"

      expect(page).to have_content('Create New Item')
      click_link('Create New Item')
      expect(current_path).to eq("/merchants/#{merchant1.id}/items/new")

      fill_in 'item_name', with: 'Chimpanzee Cheese'
      fill_in 'item_description', with: 'banana flavored cheese'
      fill_in 'item_unit_price', with: 2122
      click_on('Submit')

      expect(current_path).to eq("/merchants/#{merchant1.id}/items")
      expect(page).to have_content('Chimpanzee Cheese')
    end
  end

  describe '#User story #29' do
    it 'can show the top 5 items based off revenue ' do
      customer1 = Customer.create!(first_name: 'Jeremy', last_name: 'Fisher')
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item_1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item_2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)
      item_3 = merchant1.items.create!(name: 'Lemure lip gloss', description: 'A furry mystery', unit_price: 3)
      item_4 = merchant1.items.create!(name: 'Chimp cheese', description: 'A sticky mystery', unit_price: 33)
      item_5 = merchant1.items.create!(name: 'Gorilla Tape', description: 'A furry mystery', unit_price: 3)
      item_6 = merchant1.items.create!(name: 'Orangutang Tang', description: 'A sticky mystery', unit_price: 33)

      invoice_6 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_7 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_8 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_9 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_10 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_11 = Invoice.create!(customer_id: customer1.id, status: 1)

      transaction_1 = Transaction.create!(invoice_id: invoice_6.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_2 = Transaction.create!(invoice_id: invoice_7.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_3 = Transaction.create!(invoice_id: invoice_8.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_4 = Transaction.create!(invoice_id: invoice_9.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_5 = Transaction.create!(invoice_id: invoice_10.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_6 = Transaction.create!(invoice_id: invoice_11.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')

      invoice_item_6 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_6.id, status: 2, quantity: 1,
                                           unit_price: 50)
      invoice_item_7 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_7.id, status: 2, quantity: 1,
                                           unit_price: 45)
      invoice_item_8 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_8.id, status: 2, quantity: 1,
                                           unit_price: 40)
      invoice_item_9 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_9.id, status: 2, quantity: 1,
                                           unit_price: 35)
      invoice_item_10 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_10.id, status: 2, quantity: 1,
                                            unit_price: 30)
      invoice_item_11 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_11.id, status: 2, quantity: 1,
                                            unit_price: 5)

      visit "/merchants/#{merchant1.id}/items"
      within '.top_five_items' do
        expect(page).to have_link(item_1.name.titleize)
        expect(page).to have_link(item_2.name.titleize)
        expect(page).to have_link(item_3.name.titleize)
        expect(page).to have_link(item_4.name.titleize)
        expect(page).to have_link(item_5.name.titleize)
        expect(page).to_not have_content(item_6.name)
        expect(item_1.name.titleize).to appear_before(item_2.name.titleize)
        expect(item_2.name.titleize).to appear_before(item_3.name.titleize)
        expect(item_3.name.titleize).to appear_before(item_4.name.titleize)
        expect(item_4.name.titleize).to appear_before(item_5.name.titleize)
      end
    end

    it 'shows the top 5 items total sales' do
      customer1 = Customer.create!(first_name: 'Jeremy', last_name: 'Fisher')
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item_1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item_2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)
      item_3 = merchant1.items.create!(name: 'Lemure lip gloss', description: 'A furry mystery', unit_price: 3)
      item_4 = merchant1.items.create!(name: 'Chimp cheese', description: 'A sticky mystery', unit_price: 33)
      item_5 = merchant1.items.create!(name: 'Gorilla Tape', description: 'A furry mystery', unit_price: 3)
      item_6 = merchant1.items.create!(name: 'Orangutang Tang', description: 'A sticky mystery', unit_price: 33)

      invoice_6 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_7 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_8 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_9 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_10 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_11 = Invoice.create!(customer_id: customer1.id, status: 1)

      transaction_1 = Transaction.create!(invoice_id: invoice_6.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_2 = Transaction.create!(invoice_id: invoice_7.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_3 = Transaction.create!(invoice_id: invoice_8.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_4 = Transaction.create!(invoice_id: invoice_9.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_5 = Transaction.create!(invoice_id: invoice_10.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_6 = Transaction.create!(invoice_id: invoice_11.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')

      invoice_item_6 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_6.id, status: 2, quantity: 1,
                                           unit_price: 50)
      invoice_item_7 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_7.id, status: 2, quantity: 1,
                                           unit_price: 45)
      invoice_item_8 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_8.id, status: 2, quantity: 1,
                                           unit_price: 40)
      invoice_item_9 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_9.id, status: 2, quantity: 1,
                                           unit_price: 35)
      invoice_item_10 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_10.id, status: 2, quantity: 1,
                                            unit_price: 30)
      invoice_item_11 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_11.id, status: 2, quantity: 1,
                                            unit_price: 5)

      visit "/merchants/#{merchant1.id}/items"
      within '.top_five_items' do
        expect(page).to have_content("Item: #{item_1.name}")
        expect(page).to have_content("Total Sales: #{invoice_item_6.quantity * invoice_item_6.unit_price}")
      end
    end

    it 'has the top 5 items as links to their show page' do
      customer1 = Customer.create!(first_name: 'Jeremy', last_name: 'Fisher')
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item_1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item_2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)
      item_3 = merchant1.items.create!(name: 'Lemure lip gloss', description: 'A furry mystery', unit_price: 3)
      item_4 = merchant1.items.create!(name: 'Chimp cheese', description: 'A sticky mystery', unit_price: 33)
      item_5 = merchant1.items.create!(name: 'Gorilla Tape', description: 'A furry mystery', unit_price: 3)
      item_6 = merchant1.items.create!(name: 'Orangutang Tang', description: 'A sticky mystery', unit_price: 33)

      invoice_6 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_7 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_8 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_9 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_10 = Invoice.create!(customer_id: customer1.id, status: 1)
      invoice_11 = Invoice.create!(customer_id: customer1.id, status: 1)

      transaction_1 = Transaction.create!(invoice_id: invoice_6.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_2 = Transaction.create!(invoice_id: invoice_7.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_3 = Transaction.create!(invoice_id: invoice_8.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_4 = Transaction.create!(invoice_id: invoice_9.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_5 = Transaction.create!(invoice_id: invoice_10.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_6 = Transaction.create!(invoice_id: invoice_11.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')

      invoice_item_6 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_6.id, status: 2, quantity: 1,
                                           unit_price: 50)
      invoice_item_7 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_7.id, status: 2, quantity: 1,
                                           unit_price: 45)
      invoice_item_8 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_8.id, status: 2, quantity: 1,
                                           unit_price: 40)
      invoice_item_9 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_9.id, status: 2, quantity: 1,
                                           unit_price: 35)
      invoice_item_10 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_10.id, status: 2, quantity: 1,
                                            unit_price: 30)
      invoice_item_11 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_11.id, status: 2, quantity: 1,
                                            unit_price: 5)

      visit "/merchants/#{merchant1.id}/items"
      within '.top_five_items' do
        expect(page).to have_content("Item: #{item_1.name}")
        click_on item_1.name
      end
      expect(current_path).to eq("/merchants/#{merchant1.id}/items/#{item_1.id}")
    end
  end

  describe '#User story #28' do
    it 'shows the top 5 items best sales day' do
      customer1 = Customer.create!(first_name: 'Jeremy', last_name: 'Fisher')
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item_1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item_2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)
      item_3 = merchant1.items.create!(name: 'Lemure lip gloss', description: 'A furry mystery', unit_price: 3)
      item_4 = merchant1.items.create!(name: 'Chimp cheese', description: 'A sticky mystery', unit_price: 33)
      item_5 = merchant1.items.create!(name: 'Gorilla Tape', description: 'A furry mystery', unit_price: 3)
      item_6 = merchant1.items.create!(name: 'Orangutang Tang', description: 'A sticky mystery', unit_price: 33)

      invoice_6 = Invoice.create!(customer_id: customer1.id, status: 1, created_at: '2013-03-25 09:54:09 UTC')
      invoice_7 = Invoice.create!(customer_id: customer1.id, status: 1, created_at: '2013-03-25 09:54:09 UTC')
      invoice_8 = Invoice.create!(customer_id: customer1.id, status: 1, created_at: '2014-03-25 09:54:09 UTC')
      invoice_9 = Invoice.create!(customer_id: customer1.id, status: 1, created_at: '2016-03-25 09:54:09 UTC')
      invoice_10 = Invoice.create!(customer_id: customer1.id, status: 1, created_at: '2015-03-25 09:54:09 UTC')
      invoice_11 = Invoice.create!(customer_id: customer1.id, status: 1, created_at: '2012-03-25 09:54:09 UTC')
      invoice_12 = Invoice.create!(customer_id: customer1.id, status: 1, created_at: '2012-03-25 09:54:09 UTC')

      transaction_1 = Transaction.create!(invoice_id: invoice_6.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_2 = Transaction.create!(invoice_id: invoice_7.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_3 = Transaction.create!(invoice_id: invoice_8.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_4 = Transaction.create!(invoice_id: invoice_9.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_5 = Transaction.create!(invoice_id: invoice_10.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')
      transaction_6 = Transaction.create!(invoice_id: invoice_11.id, result: 'success', credit_card_number: '123456789',
                                          credit_card_expiration_date: '1/2/99')

      invoice_item_6 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_6.id, status: 2, quantity: 1,
                                           unit_price: 50)
      invoice_item_7 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_7.id, status: 2, quantity: 1,
                                           unit_price: 45)
      invoice_item_8 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_8.id, status: 2, quantity: 1,
                                           unit_price: 40)
      invoice_item_9 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_9.id, status: 2, quantity: 1,
                                           unit_price: 35)
      invoice_item_10 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_10.id, status: 2, quantity: 1,
                                            unit_price: 30)
      invoice_item_11 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_11.id, status: 2, quantity: 1,
                                            unit_price: 5)
      invoice_item_12 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_6.id, status: 2, quantity: 1,
                                            unit_price: 50)

      visit "/merchants/#{merchant1.id}/items"
      within '.top_five_items' do
        expect(page).to have_content("Top Sales Date: #{invoice_6.creation_date_formatted}")
        expect(page).to have_content("Top Sales Date: #{invoice_7.creation_date_formatted}")
        expect(page).to have_content("Top Sales Date: #{invoice_8.creation_date_formatted}")
        expect(page).to have_content("Top Sales Date: #{invoice_9.creation_date_formatted}")
        expect(page).to have_content("Top Sales Date: #{invoice_10.creation_date_formatted}")
        expect(page).to_not have_content(invoice_12.created_at.to_date)
      end
    end
  end
end
