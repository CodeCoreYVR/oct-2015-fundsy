class CampaignsMailer < ApplicationMailer

  def notify_owner_of_pledge(campaign)
    mail(to: "tam@codecore.ca", subject: "test")
  end

end
