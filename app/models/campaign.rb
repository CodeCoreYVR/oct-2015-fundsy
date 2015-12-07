class Campaign < ActiveRecord::Base
  belongs_to :user

  has_many :comments, as: :commentable

  has_many :rewards, dependent: :destroy
  # this enables us to creates rewards at the time we create the campaign.
  # by passing in special key: rewards_attributes
  # reject_if: :all_blank will ignore all nested rewards if all the attributes
  # are blank
  accepts_nested_attributes_for :rewards, reject_if: :all_blank,
                                          allow_destroy: true

  validates :title, presence: true
  validates :goal, presence: true, numericality: {greater_than: 10}

  # this validation will ensure that the campaign has at least one reward
  validates :rewards, presence: {message: "must have at least 1 reward"}

  # we instruct geocoder about the field we would like it to geocode by. In
  # our case we only have a single database field called `address` so we can
  # just pass that in. If you had multiple fields to compose the address then
  # your can make a method that looks like:
  # def full_street_address
  #   "#{street_address} #{city} #{country} #{postal_code}"
  # end
  # then your line will be like:
  # geocoded_by :full_street_address
  geocoded_by :address

  # This will initiate the `gecode` method after it validates the record so
  # before saving you will have the `longitude` and `latitude`
  after_validation :geocode

  include AASM

  # we put all the states and transitions in the `aasm` block
  aasm whiny_transitions: false do
    state :draft, initial: true
    state :published
    state :funded
    state :unfunded
    state :closed

    event :publish do
      transitions from: :draft, to: :published
    end

    event :fund do
      transitions from: :published, to: :funded
    end

    event :unfund do
      transitions from: :published, to: :unfunded
    end

    event :close do
      transitions from: [:draft, :published], to: :closed
    end

  end

end

# c1 = Campaign.new(title: "Another campaign", description: "Another description", goal: 1000000,
# rewards_attributes: {"0" => {body: "Thank you", amount: 5}, "1" => {body: "Super Thank You", amount: 10} })
