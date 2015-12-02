class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true,
            format:{ with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :first_name, presence: true
  validates :last_name, presence: true

  # has_many :comments, as: :commentable

  def full_name
    "#{first_name} #{last_name}"
  end
end
