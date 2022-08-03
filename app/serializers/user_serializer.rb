class UserSerializer < Blueprinter::Base
  identifier :id

  field :first_name
  field :created_at
  field :updated_at
  field :last_name
  field :email
  field :role, default: 'public'
end
