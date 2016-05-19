FactoryGirl.define do
  factory :user do

    sequence :email do |n|
      "user#{n}@example.com"
    end

    sequence :first_name do |n|
      "user#{n} first_name"
    end

    sequence :last_name do |n|
      "user#{n} last_name"
    end

    password "password"
  end

end
