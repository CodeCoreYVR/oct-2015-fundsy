class CampaignsController < ApplicationController
  before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_campaign, only: [:edit, :update, :destroy, :show]

  DEFAULT_REWARD_COUNT = 2

  def new
    @campaign = Campaign.new
    # DEFAULT_REWARD_COUNT.times { @campaign.rewards.build }
  end

  def create
    service = Campaigns::CreateCampaign.new(params: campaign_params,
                                            user:   current_user)
    if service.call
      redirect_to campaign_path(service.campaign)
    else
      @campaign = service.campaign
      number_to_build = DEFAULT_REWARD_COUNT - @campaign.rewards.size
      number_to_build.times { @campaign.rewards.build }
      render :new
    end
  end

  def show
    @comment = Comment.new
    @pledge  = Pledge.new
  end

  def edit
    if @campaign.user != current_user
      redirect_to root_path, alert: "Access denied!"
    end
  end

  def update
    if @campaign.user != current_user
      redirect_to root_path
    elsif @campaign.update campaign_params
      redirect_to campaign_path(@campaign)
    else
      render :edit
    end
  end

  def index
    @campaigns = Campaign.includes(:rewards).references(:rewards).order(:created_at)
    respond_to do |format|
      format.html { render }
      format.json { render json: @campaigns.to_json }
    end
  end

  def destroy
    if current_user == @campaign.user
      @campaign.destroy
      redirect_to campaigns_path
    else
      redirect_to root_path
    end
  end

  private

  def find_campaign
    # @campaign = @campaign.decorate
    @campaign = Campaign.find(params[:id]).decorate
  end

  def campaign_params
    params.require(:campaign).permit(:title, :goal, :description, :end_date,
                                      :address,
                                     rewards_attributes: [:amount, :body, :id,
                                                          :_destroy])
  end

end
