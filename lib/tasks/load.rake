require 'csv'
require 'task_helper/application_helper'
include ApplicationHelper

desc 'Imports a customer file into an ActiveRecord table'
task :customer, [:filename] => :environment do
  CSV.foreach('./db/data/customers.csv', headers: true) do |row|
    Customer.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE customers_id_seq RESTART WITH #{Customer.maximum(:id) + 1}")
end

desc 'Imports an invoice_item file into an ActiveRecord table'
task :invoiceitem, [:filename] => :environment do
  CSV.foreach('./db/data/invoice_items.csv', headers: true) do |row|
    InvoiceItem.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE invoice_items_id_seq RESTART WITH #{InvoiceItem.maximum(:id) + 1}")
end

desc 'Imports an invoice file into an ActiveRecord table'
task :invoice, [:filename] => :environment do
  CSV.foreach('./db/data/invoices.csv', headers: true) do |row|
    Invoice.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE invoices_id_seq RESTART WITH #{Invoice.maximum(:id) + 1}")
end

desc 'Imports an merchants file into an ActiveRecord table'
task :merchant, [:filename] => :environment do
  CSV.foreach('./db/data/merchants.csv', headers: true) do |row|
    Merchant.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE merchants_id_seq RESTART WITH #{Merchant.maximum(:id) + 1}")
end

desc 'Imports an item file into an ActiveRecord table'
task :item, [:filename] => :environment do
  CSV.foreach('./db/data/items.csv', headers: true) do |row|
    Item.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE items_id_seq RESTART WITH #{Item.maximum(:id) + 1}")
end

desc 'Imports a transaction file into an ActiveRecord table'
task :transaction, [:filename] => :environment do
  CSV.foreach('./db/data/transactions.csv', headers: true) do |row|
    Transaction.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE transactions_id_seq RESTART WITH #{Transaction.maximum(:id) + 1}")
end

desc 'Add bulk discounts'
task :bulk_discount, [:filename] => :environment do
  300.times do
    discounts = [5, 10, 15, 20]
    thresholds = [2, 5, 7]
    merchant = Merchant.all.sample
    if merchant.bulk_discounts.any?
      discount = merchant.bulk_discounts.last.discount + 5
      next if merchant.bulk_discounts.last.discount > 25

      threshold = merchant.bulk_discounts.last.threshold + 2
      merchant.bulk_discounts.create(name: Faker::Date.in_date_period(year: 2022), threshold: threshold,
                                     discount: discount)
    else
      merchant.bulk_discounts.create(name: Faker::Date.in_date_period(year: 2022),
                                     threshold: thresholds.sample(1).join.to_i, discount: discounts.sample(1).join.to_i)
    end
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE bulk_discounts_id_seq RESTART WITH #{BulkDiscount.maximum(:id) + 1}")
  end
end

desc 'destroy the tables'
task destroy_all: :environment do
  InvoiceItem.destroy_all
  Item.destroy_all
  BulkDiscount.destroy_all
  Merchant.destroy_all
  Transaction.destroy_all
  Invoice.destroy_all
  Customer.destroy_all
end

desc 'Import all in order'
task all: %i[destroy_all customer invoice transaction merchant bulk_discount item invoiceitem] # ordered appropriately.
