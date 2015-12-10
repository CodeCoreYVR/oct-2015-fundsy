FactoryGirl.define do
  factory :pledge do
    amount ""
stripe_txn_id "MyString"
aasm_state "MyString"
user nil
campaign nil
  end

end
