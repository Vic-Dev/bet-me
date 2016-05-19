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

  # factory :challenges do

  #   sequence :title do |n|
  #     "user#{n} title"
  #   end

  #   sequence :description do |n|
  #     "user#{n} description"
  #   end

  #   sequence :wager do |n|
  #     "#{n}0"
  #   end

  #   sequence "start_time" do |n|
  #     Date.today + n.days
  #   end

  #   sequence "end_time" do |n|
  #     Date.today + (2 * n.days)
  #   end
  # end
  
end
