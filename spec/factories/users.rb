FactoryBot.define do
  factory :user do
    first_name { 'Ivica' }
    last_name { 'Todoric' }
    email { "#{first_name.downcase}#{last_name.downcase}@mail.com" }
    password { 'test' }
  end
end
