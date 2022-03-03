require 'rails_helper'

 RSpec.describe 'Merchant Dashboard' do
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

  describe 'user story #40' do
    xit "when visiting merchant dashboard I see name of merchant" do
      expect(page).to have_content(@merchant_1.id)
      # binding.pry
    end
  end

  describe 'user story #39' do
    xit "when visiting merchant dashboard I see a link to merchant invoices index" do
      click_link 'Invoices'

      expect(page).to have_content(@merchant_1.id)
    end
  end


describe 'user story #38' do
  xit "when visiting merchant dashboard I see a link to merchant invoices index" do
    click_link 'Invoices'

    expect(page).to have_content('Bosco, Howe and Davis')
  end
  xit 'is able to list top 5 customers for this merchant' do
    # visit "/merchants/#{@merchant_1.id}/dashboard"
    within ".top_customers" do
      expect(page).to have_content("#{@customer_2.name}, 9")
      expect(page).to have_content("#{@customer_3.name}, 9")
      expect(page).to have_content("#{@customer_1.name}, 4")
      expect(page).to have_content("#{@customer_4.name}, 4")
      expect(page).to have_content("#{@customer_5.name}, 1")

      expect(@customer_2.name).to appear_before(@customer_3.name)
      expect(@customer_3.name).to appear_before(@customer_1.name)
      expect(@customer_1.name).to appear_before(@customer_4.name)
      expect(@customer_4.name).to appear_before(@customer_5.name)
      expect(page).to_not have_content("#{@customer_6.name}, 34")
    end
  end

    # it 'shows the names of the top 5 customers with successful transactions' do
    #   within("#customer-#{@customer_1.id}") do
    #     expect(page).to have_content(@customer_1.first_name)
    #     expect(page).to have_content(@customer_1.last_name)
    #
    #     expect(page).to have_content(3)
    #   end
    #   within("#customer-#{@customer_2.id}") do
    #     expect(page).to have_content(@customer_2.first_name)
    #     expect(page).to have_content(@customer_2.last_name)
    #     expect(page).to have_content(1)
    #   end
    #   within("#customer-#{@customer_3.id}") do
    #     expect(page).to have_content(@customer_3.first_name)
    #     expect(page).to have_content(@customer_3.last_name)
    #     expect(page).to have_content(1)
    #   end
    #   within("#customer-#{@customer_4.id}") do
    #     expect(page).to have_content(@customer_4.first_name)
    #     expect(page).to have_content(@customer_4.last_name)
    #     expect(page).to have_content(1)
    #   end
    #   within("#customer-#{@customer_5.id}") do
    #     expect(page).to have_content(@customer_5.first_name)
    #     expect(page).to have_content(@customer_5.last_name)
    #     expect(page).to have_content(1)
    #   end
    #
    #   expect(page).to have_no_content(@customer_6.first_name)
    #   expect(page).to have_no_content(@customer_6.last_name)
    # end
  end

end
