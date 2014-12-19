namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    clean
    make_users
    make_feedbacks
    make_tags
  end
end

def clean
  User.all.delete_all
  Feedback.all.delete_all
end

def make_users
  User.create!(
    email: 'foo@bar.com',
    name: 'Foo Bar',
    password: 'foobar'
  )

  3.times do
    User.create!(
      email: Faker::Internet.email,
      name: Faker::Name.name,
      password: '123456'
    )
  end
end

def make_feedbacks
  User.all[0..3].each do |user|
    10.times do |index|
      Feedback.create!(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        user_id: user.id
      )
    end
  end
end

def make_tags
  10.times do
    Tag.create!(
      label: Faker::Lorem.word
    )
  end
end
