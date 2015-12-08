class Campaigns::CreateCampaign

  include Virtus.model

  # virtus will give us attribute accessor for the attributes defined below

  # input
  attribute :params, Hash
  attribute :user, User

  # output
  attribute :campaign, Campaign

  def call
    @campaign      = Campaign.new params
    @campaign.user = user
    @campaign.save
  end


end
