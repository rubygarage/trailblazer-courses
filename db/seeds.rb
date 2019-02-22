# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  email: FFaker::Internet.unique.email,
  first_name: FFaker::Name.first_name,
  last_name: FFaker::Name.last_name,
  password: "Administrator1!",
  is_admin: true
)

10.times do |index|
  User.create(
    email: FFaker::Internet.unique.email,
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    password: "Password#{index}!",
    is_admin: false
  )
end
