class Payments::HandlePayment
  include Virtus.model

  attribute :pledge, Pledge
  attribute :stripe_token, String
  attribute :current_user, User

  def call
    begin
      update_user_stripe_info
      charge_and_update_pledge
    rescue Stripe::InvalidRequestError => e
      # this will caputure stripe errors with Stripe::InvalidRequestError exception
    rescue => e
      Rails.logger.info e.inspect
      # notify admin with errors details inside the `e` object
      false
    end
  end

  private

  def charge_and_update_pledge
    pledge.stripe_txn_id = stripe_charge.id
    pledge.pay
    pledge.save
  end

  def stripe_charge
    @stripe_charge ||= Stripe::Charge.create(
                        :amount => (pledge.amount * 100).to_i,
                        :currency => "cad",
                        :customer => current_user.stripe_customer_id,
                        :description => "Pledge for Campaign ID #{pledge.campaign_id}"
                        )
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.create(
                        :description => "Fund.sy Customer for #{current_user.id}",
                        :source => stripe_token
                      )
  end


  def update_user_stripe_info
    # updating the user records with the customer infomration from Stripe
    current_user.card_last_4        = stripe_customer.sources.data[0].last4
    current_user.card_type          = stripe_customer.sources.data[0].brand
    current_user.stripe_customer_id = stripe_customer.id
    current_user.save
  end

end
