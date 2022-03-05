require 'csv'
require 'task_helper/application_helper'
include ApplicationHelper

desc 'Imports a customer file into an ActiveRecord table'
task :customer, [:filename] => :environment do
  import_data('./db/data/customers.csv', Customer)
end

desc 'Imports an invoice_item file into an ActiveRecord table'
task :invoiceitem, [:filename] => :environment do
  import_data('./db/data/invoice_items.csv', InvoiceItem)
end

desc 'Imports an invoice file into an ActiveRecord table'
task :invoice, [:filename] => :environment do
  import_data('./db/data/invoices.csv', Invoice)
end

desc 'Imports an merchants file into an ActiveRecord table'
task :merchant, [:filename] => :environment do
  import_data('./db/data/merchants.csv', Merchant)
end

desc 'Imports an item file into an ActiveRecord table'
task :item, [:filename] => :environment do
  import_data('./db/data/items.csv', Item)
end

desc 'Imports a transaction file into an ActiveRecord table'
task :transaction, [:filename] => :environment do
  import_data('./db/data/transactions.csv', Transaction)
end

desc 'Add bulk discounts' 
task :bulk_discount, [:filename] => :environment do
  300.times do 
    discounts = [5,10,15,20]
    thresholds = [2,5,10,15,20]
    merchant = Merchant.all.sample
    if merchant.bulk_discounts.any?
      discount = merchant.bulk_discounts.last.discount + 5
      threshold = merchant.bulk_discounts.last.threshold + 5
      merchant.bulk_discounts.create(name: Faker::Date.in_date_period(year: 2022), threshold: threshold, discount: discount)
    else
      merchant.bulk_discounts.create(name: Faker::Date.in_date_period(year: 2022), threshold: thresholds.sample(1).join.to_i, discount: discounts.sample(1).join.to_i)
    end
  end
end

desc 'destroy the tables'
task destroy_all: :environment do
  BulkDiscount.destroy_all
  InvoiceItem.destroy_all
  Item.destroy_all
  Merchant.destroy_all
  Transaction.destroy_all
  Invoice.destroy_all
  Customer.destroy_all
end

desc 'Import all in order'
task all: %i[destroy_all customer invoice transaction merchant item invoiceitem bulk_discount]
