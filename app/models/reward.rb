class Reward < ActiveRecord::Base
  belongs_to :campaign

  validates :amount, presence: true
  validates :body, presence: true
end
