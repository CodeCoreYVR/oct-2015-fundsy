class PaymentsController < ApplicationController
  before_action :authenticate_user

  def new
    @pledge = Pledge.find params[:pledge_id]
  end

  def create
    @pledge = Pledge.find params[:pledge_id]
    service = Payments::HandlePayment.new(pledge:       @pledge,
                                          stripe_token: params[:stripe_token],
                                          current_user: current_user)
    if service.call
      redirect_to @pledge.campaign, notice: "Thanks for the payment"
    else
      redirect_to new_pledge_payment_path(@pledge), alert: "Try again!"
    end
  end


end
