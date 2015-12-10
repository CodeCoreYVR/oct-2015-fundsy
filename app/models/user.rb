class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true,
            format:{ with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
            unless: :from_omniauth?
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :campaigns, dependent: :destroy

  has_many :pledges, dependent: :nullify
  has_many :pledged_campaigns, through: :pledges, source: :campaign

  # this enables us to store Hash data (or Array) and Rails will take care of
  # `encoding` and `decoding` the Hash data so you can easily store it and
  # retrieve it.
  serialize :twitter_raw_data

  geocoded_by :address
  after_validation :geocode

  before_create :generate_api_key

  # has_many :comments, as: :commentable

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def from_omniauth?
    uid.present? && provider.present?
  end

  def generate_api_key
    begin
      # SecureRandom is a class that helps us generate a randon String. We can
      # use methods on it like SecureRandom.hex or SecureRandom.urlsafe_base64
      self.api_key = SecureRandom.hex(32)
    end while User.exists?(api_key: self.api_key)
  end
end
