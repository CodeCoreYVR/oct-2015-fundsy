FactoryGirl.define do
  factory :reward do
    amount {10 + rand(1000) }
    body { Faker::Company.bs }
  end

end
