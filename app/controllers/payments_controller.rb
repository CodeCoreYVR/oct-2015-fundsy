class PaymentsController < ApplicationController
  before_action :authenticate_user

  def new
    @pledge = Pledge.find params[:pledge_id]
  end

end
