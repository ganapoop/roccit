require 'random_data'
# Create Topics
15.times do
  Topic.create!(
  name:         Faker::Hipster.sentence,
  description:  RandomData.random_paragraph
  )
end
topics = Topic.all


#Create posts
50.times do

  Post.create!(
  topic: topics.sample,
  title: Faker::Hipster.sentence,
  body:  RandomData.random_paragraph
  )
end

posts = Post.all

#Create comments

100.times do
  Comment.create!(
  post: posts.sample,
  body: RandomData.random_paragraph
  )
end

30.times do
  SponsoredPost.create!(
  topic: topics.sample,
  title: Faker::Hipster.sentence,
  body:  RandomData.random_paragraph,
  price: 100
  )
end

sponsored_posts = SponsoredPost.all

puts "Seed finished"
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{SponsoredPost.count} sponsored posts created."
