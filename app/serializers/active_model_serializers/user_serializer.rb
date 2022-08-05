module ActiveModelSerializers
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
    attributes :created_at, :updated_at
  end
end
