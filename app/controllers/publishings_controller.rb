class PublishingsController < ApplicationController
  before_action :authenticate_user

  def create
    campaign = Campaign.find params[:campaign_id]
    if campaign.publish
      campaign.save


      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.secrets.twitter_consumer_key
        config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
        config.access_token        = current_user.twitter_client_token
        config.access_token_secret = current_user.twitter_client_secret
      end
      
      client.update("#{campaign.title} has been published! #{campaign_url(campaign)}")



      redirect_to campaign, notice: "Campaign Published!"
    else
      redirect_to campaign, alert: "Error! Can't publish campaign."
    end
  end

end
