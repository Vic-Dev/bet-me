#TODO fix records that are COMPLETED - the time is in the future LOL


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
# 
# Challenge.create(
# title: Faker::Book.title,
# description: Faker::Hipster.paragraph,
# wager: Faker::Number.between(10,500),
# start_time: Faker::Time.between(Date.today - 20, Date.today - 10),
# end_time: Faker::Time.between(Date.today - 5, Date.today - 2)
# )
#
# Record.create(challenge_id: 11, user_id: 5, role: "creator", is_active: false, is_completed: true)

def create_voters(n, start_id, challenge_id_given, is_completed=true)
  n.times do |x|
    challenge_id = challenge_id_given
    user_id =  x + start_id
    role = "voter"
    is_active = true
    vote_result = is_completed ? Faker::Boolean.boolean : nil 
    record = Record.where('challenge_id = ? AND role = ?', challenge_id_given, "creator").take
    if record[:is_completed]
      is_completed = true
    else
      is_completed = false
    end
    Record.create(
      challenge_id: challenge_id,
      user_id: user_id,
      role: role,
      vote_result: vote_result,
      is_active: is_active,
      is_completed: is_completed
      )
  end
end

create_voters(4, 1, 1)

Record.create(challenge_id: 1, user_id: 5, role: "creator", is_active: false, is_completed: true)

create_voters(3, 6, 2, false)

Record.create(challenge_id: 2, user_id: 2, role: "creator", is_active: true, is_completed: false)

create_voters(2, 5, 3, false)

Record.create(challenge_id: 3, user_id: 1, role: "creator", is_active: true, is_completed: false)

Record.create(challenge_id: 4, user_id: 1, role: "creator", is_active: true, is_completed: false)

create_voters(5, 5, 5)

Record.create(challenge_id: 5, user_id: 1, role: "creator", is_active: false, is_completed: true)

create_voters(1, 2, 6)

Record.create(challenge_id: 6, user_id: 1, role: "creator", is_active: false, is_completed: true)

create_voters(2, 2, 7, false)

Record.create(challenge_id: 7, user_id: 1, role: "creator", is_active: true, is_completed: false)

create_voters(3, 3, 8)

Record.create(challenge_id: 8, user_id: 2, role: "creator", is_active: false, is_completed: true)

create_voters(2, 5, 9, false)

Record.create(challenge_id: 9, user_id: 2, role: "creator", is_active: true, is_completed: false)

create_voters(3, 1, 10, false)

Record.create(challenge_id: 10, user_id: 6, role: "creator", is_active: true, is_completed: false)
