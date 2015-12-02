class Campaign < ActiveRecord::Base
  belongs_to :user

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
end

# c1 = Campaign.new(title: "Another campaign", description: "Another description", goal: 1000000,
# rewards_attributes: {"0" => {body: "Thank you", amount: 5}, "1" => {body: "Super Thank You", amount: 10} })
