class Pledge < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign

  validates :amount, presence: true,
                     numericality: {greater_than_or_equal_to: 1}

  include AASM

  aasm whiny_transitions: false do
    state :pending, initial: true
    state :paid
    state :refunded

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :refund do
      transitions from: :paid, to: :refunded
    end

  end

end
