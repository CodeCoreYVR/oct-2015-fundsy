class PledgesController < ApplicationController
  before_action :authenticate_user

  def create
    @campaign = Campaign.find(params[:campaign_id]).decorate
    @pledge   = @campaign.pledges.new pledge_params
    @comment  = Comment.new
    if @pledge.save
      CampaignsMailer.notify_owner_of_pledge(@campaign.object).deliver_now
      redirect_to new_pledge_payment_path(@pledge), notice: "Please make a payment"
    else
      render "/campaigns/show"
    end
  end

  private

  def pledge_params
    params.require(:pledge).permit(:amount)
  end
end
