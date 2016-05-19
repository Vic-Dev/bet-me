FactoryGirl.define do
  factory :challenge do

    sequence :title do |n|
      "user#{n} title"
    end

    sequence :description do |n|
      "user#{n} description"
    end

  end

end

