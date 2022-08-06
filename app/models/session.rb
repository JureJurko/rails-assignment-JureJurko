class Session
  attr_reader :email, :password

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def valid?
    return false if user.nil?

    user.authenticate(password)
  end

  def user
    @user ||= User.find { |user| user.email == email }
  end
end
