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
