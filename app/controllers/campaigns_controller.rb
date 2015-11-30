class CampaignsController < ApplicationController
  before_action :authenticate_user, only: [:new, :create, :edit]

  def new
    @campaign = Campaign.new
  end

  def create
    campaign_params = params.require(:campaign).permit(:title, :goal,
                                                       :description, :end_date)
    @campaign = Campaign.new campaign_params
    @campaign.user = current_user
    if @campaign.save
      redirect_to campaign_path(@campaign)
    else
      render :new
    end
  end

  def show
    @campaign = Campaign.find params[:id]
  end

  def edit
    @campaign = Campaign.find params[:id]
    if @campaign.user != current_user
      redirect_to root_path, alert: "Access denied!"
    end
  end

end
