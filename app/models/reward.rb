class Reward < ActiveRecord::Base
  # touch: true will update the associated campaign by just setting the
  # `updated_at` field on it when a Reward is created or updated.
  belongs_to :campaign, touch: true

  validates :amount, presence: true
  validates :body, presence: true
end
