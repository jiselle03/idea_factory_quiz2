# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

User.destroy_all()
Idea.destroy_all()
Review.destroy_all()
Like.destroy_all()

PASSWORD = "supersecret"  

super_user = User.create( 
    first_name: "Padme", 
    last_name: "Amidala", 
    email: "padme@naboo.gov", 
    password: PASSWORD,
    is_admin: true
) 

10.times do 
    full_name = Faker::Movies::StarWars.character.split(' ')
    first_name = full_name[0]
    last_name = full_name[1]
    User.create( 
        first_name: first_name, 
        last_name: last_name,  
        email: "#{first_name}.#{last_name}@#{Faker::Movies::StarWars.planet}.com", 
        password: PASSWORD 
    )  
end 

users = User.all 
puts Cowsay.say("Created #{users.count} users.", :dragon)  
puts "Login with #{super_user.email} and password of '#{PASSWORD}'."

100.times do
    random_date = Faker::Date.backward(days:365 * 5)
    i = Idea.create(
        title: Faker::Movies::StarWars.quote,
        description: Faker::Movies::StarWars.wookiee_sentence,
        created_at: random_date,
        updated_at: random_date,
        user: users.sample
    )
    if i.valid?
        rand(0..15).times.map do
            r = Review.create(
                body: Faker::Movies::StarWars.quote, 
                idea: i,
                user: users.sample
                )
        end
        i.likers = users.shuffle.slice(0..rand(users.count))
    end
end

puts Cowsay.say("Generated #{Idea.count} ideas.", :frogs)
puts Cowsay.say("Generated #{Review.count} reviews.", :frogs)
puts Cowsay.say("Generated #{Like.count} likes.", :tux)