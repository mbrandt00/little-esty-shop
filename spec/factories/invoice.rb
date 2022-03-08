FactoryBot.define do
  factory :invoice, class: Invoice do
    status { (['completed', 'cancelled', 'inprogress']).sample(1)[0] } # What should we pass?
    customer
  end
end
