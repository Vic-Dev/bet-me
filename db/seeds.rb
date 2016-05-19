10.times do
  email = Faker::Internet.email
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    email: email,
    first_name: first_name,
    last_name: last_name,
    password: "123"
  )
end

10.times do
  title = Faker::Book.title
  description = Faker::Hipster.paragraph
  wager = Faker::Number.between(10, 500)
  start_time = Faker::Time.between(DateTime.now + 2, DateTime.now + 30)
  end_time = Faker::Time.between(start_time, start_time + 90)
  Challenge.create(
    title: title,
    description: description,
    wager: wager,
    start_time: start_time,
    end_time: end_time
  )
end


# 4.times do |n|
#   challenge_id = 1
#   user_id =  n + 1
#   role = "voter"
#   Record.create(
#     challenge_id: challenge_id,
#     user_id: user_id,
#     role: role,
#     vote_result: Faker::Boolean.boolean
#   )
# end

# Record.create(challenge_id: 1, user_id: 5, role: "creator", is_active: true, is_completed: true)