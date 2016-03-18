class DetermineFundingStateJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    campaign = args[0]
    pledges_total = campaign.pledges.sum(:amount)
    if pledges_total >= campaign.goal
      campaign.fund!
    else
      campaign.unfund!
    end
  end
end
