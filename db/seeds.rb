#Create Users

  5.times do
    user = User.create!(
      name:     RandomData.random_name,
      email:    Faker::Internet.email,
      password: RandomData.random_sentence
    )
  end
  users = User.all
# Create topics
  15.times do
    Topic.create!(
      name:         Faker::Hipster.sentence,
      description:  RandomData.random_paragraph
    )
  end
  topics = Topic.all


# Create posts
  50.times do

    Post.create!(
      user:  users.sample,
      topic: topics.sample,
      title: RandomData.random_sentence,
      body:  RandomData.random_paragraph
    )
  end
  posts = Post.all

  #Create comments

  100.times do
    Comment.create!(

      post: posts.sample,
      body:  RandomData.random_paragraph
    )
  end
  #create admin user
  # Create an admin user
 admin = User.create!(
   name:     'Admin User',
   email:    'admin@example.com',
   password: 'helloworld',
   role:     'admin'
 )

 # Create a member
 member = User.create!(
   name:     'Member User',
   email:    'member@example.com',
   password: 'helloworld'
 )

puts "Seed finished"
puts "#{User.count} users created."
puts "#{Topic.count} topics created."
puts "#{Post.count} posts created."
puts "#{Comment.count} comments created."
