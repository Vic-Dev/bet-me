#TODO fix records that are COMPLETED - the time is in the future LOL

11.times do
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

10.times do |x|
  title = Faker::Book.title
  description = Faker::Hipster.paragraph
  wager = Faker::Number.between(10, 500)
  start_time = Faker::Time.between(DateTime.now + 10, DateTime.now + 30).utc
  end_time = Faker::Time.between(start_time, start_time + 30).utc
  Challenge.create(
    title: title,
    description: description,
    wager: wager,
    start_time: start_time,
    end_time: end_time,
    user_id: (x + 1)
  )
  Voter.create(
    challenge_id: (x + 1),
    user_id: (x + 2),
    accepted_invite: false,
  )
end

title = Faker::Book.title
description = Faker::Hipster.paragraph
wager = Faker::Number.between(10, 500)
time_now = Time.now.utc

challenge = Challenge.create(title: title, description: description, wager: wager, start_time: time_now, end_time: time_now, user_id: 1)
Voter.create(challenge_id: challenge.id, user_id: 2, accepted_invite: false, vote: true)
Voter.create(challenge_id: challenge.id, user_id: 3, accepted_invite: false, vote: true)
Voter.create(challenge_id: challenge.id, user_id: 4, accepted_invite: false, vote: false)
Voter.create(challenge_id: challenge.id, user_id: 5, accepted_invite: false, vote: false)