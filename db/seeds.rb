require 'faker'
include FactoryGirl::Syntax::Methods

10.times do
  FactoryGirl.create(:user)
end  

10.times do
  FactoryGirl.create(:challenge)
end


4.times do |n|
  challenge_id = 1
  user_id =  n + 1
  role = "voter"
  Record.create(
    challenge_id: challenge_id,
    user_id: user_id,
    role: role,
    vote_result: Faker::Boolean.boolean
  )
end

Record.create(challenge_id: 1, user_id: 5, role: "creator", is_active: true, is_completed: true)

