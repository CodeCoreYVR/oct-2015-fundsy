class Api::V1::CampaignsController < ApplicationController

  def index
    @campaigns = Campaign.includes(:rewards).references(:rewards).
                          order(:created_at).decorate
    # render json: @campaigns, each_serializer: CampaignSerializer
  end

  def show
    campaign = Campaign.find params[:id]
    render json: campaign
  end

end
