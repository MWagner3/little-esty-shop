require 'rails_helper'

RSpec.describe Merchant do
  describe 'relations' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    before :each do
      @merchant_1 = Merchant.create!(name: "LT's Tee Shirts LLC", status: 0)
      @merchant_2 = Merchant.create!(name: 'Handmade in CO Co.', status: 1)
      @merchant_3 = Merchant.create!(name: 'Happy Crafts', status: 1)
      @merchant_4 = Merchant.create!(name: 'Not-So-Happy Crafts')

      visit '/admin/merchants'
    end

    it 'returns all merchants with a status of disabled' do
      expect(Merchant.disabled).to eq([@merchant_1, @merchant_4])
    end

    it 'returns all merchants with a status of enabled' do
      expect(Merchant.enabled).to eq([@merchant_2, @merchant_3])
    end
  end

  describe 'instance methods' do
    it 'list the top five items for that merchant' do
      customer1 = Customer.create!(first_name: 'Jeremy', last_name: 'Fisher')
      merchant1 = Merchant.create!(name: 'Primate Privleges')
      item_1 = merchant1.items.create!(name: 'Monkey Paw', description: 'A furry mystery', unit_price: 3)
      item_2 = merchant1.items.create!(name: 'Gorilla Grip Glue', description: 'A sticky mystery', unit_price: 7)
      item_3 = merchant1.items.create!(name: 'Lemure lip gloss', description: 'A furry mystery', unit_price: 3)
      item_4 = merchant1.items.create!(name: 'Chimp cheese', description: 'A sticky mystery', unit_price: 33)
      item_5 = merchant1.items.create!(name: 'Gorilla Tape', description: 'A furry mystery', unit_price: 3)
      item_6 = merchant1.items.create!(name: 'Orangutang Tang', description: 'A sticky mystery', unit_price: 33)

      invoice_6 = Invoice.create!(customer_id: customer1.id, status: 2)
      invoice_7 = Invoice.create!(customer_id: customer1.id, status: 2)
      invoice_8 = Invoice.create!(customer_id: customer1.id, status: 2)
      invoice_9 = Invoice.create!(customer_id: customer1.id, status: 2)
      invoice_10 = Invoice.create!(customer_id: customer1.id, status: 2)
      invoice_11 = Invoice.create!(customer_id: customer1.id, status: 2)

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
                                           unit_price: 43)
      invoice_item_7 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_7.id, status: 1, quantity: 1,
                                           unit_price: 45)
      invoice_item_8 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_8.id, status: 1, quantity: 1,
                                           unit_price: 40)
      invoice_item_9 = InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_9.id, status: 1, quantity: 1,
                                           unit_price: 35)
      invoice_item_10 = InvoiceItem.create!(item_id: item_5.id, invoice_id: invoice_10.id, status: 1, quantity: 1,
                                            unit_price: 30)
      invoice_item_11 = InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_11.id, status: 1, quantity: 1,
                                            unit_price: 5)
      expect(merchant1.top_five_items).to eq([item_2, item_1, item_3, item_4, item_5])
    end
  end
end
