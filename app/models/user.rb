class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true,
            format:{ with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :first_name, presence: true
  validates :last_name, presence: true

  geocoded_by :address
  after_validation :geocode

  before_create :generate_api_key

  # has_many :comments, as: :commentable

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def generate_api_key
    begin
      # SecureRandom is a class that helps us generate a randon String. We can
      # use methods on it like SecureRandom.hex or SecureRandom.urlsafe_base64
      self.api_key = SecureRandom.hex(32)
    end while User.exists?(api_key: self.api_key)
  end
end
