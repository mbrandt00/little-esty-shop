FactoryBot.define do
  factory :bulk_discount, class: BulkDiscount do
    quantity { rand(1..15) }
    discount { rand(10..50) }
    sequence(:name) { |n| "rand_name#{n}" }
    merchant
  end
end