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
                                           unit_price: 43)
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
      expect(merchant1.top_five_items).to eq([item_2, item_1, item_3, item_4, item_5])
    end
    describe 'more instance methods' do
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

      xit ".top_five_customers" do
        expect(@merchant_1.top_five_customers).to eq([@customer_1, @customer_2, @customer_3, @customer_4, @customer_5])
      end
    end
  end


end
