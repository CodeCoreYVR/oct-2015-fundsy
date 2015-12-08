class CampaignDecorator < Draper::Decorator
  # delegate_all mehtod makes a decorator object behave a 100% like a Campaign
  # object in here. Which means if you have a campaign decorator object you
  # can call any method that is defined for Campaign and it will work because
  # the method will be delegated to the campaign object.
  delegate_all

  def capitalized_title
    # object references the object being decorated which is this case a Campaign
    # object.
    object.title.capitalize
  end

  def end_date
    object.end_date.strftime("%Y-%b-%d %H:%m")
  end

  def goal
    # number_to_currency is a Rails helper method`
    h.number_to_currency(object.goal)
  end

  def state_label
    h.content_tag :span, class: "label #{label_class}" do
      state
    end
  end

  def label_class
    h.label_class(object.aasm_state)
  end

  def state
    object.aasm_state.capitalize
  end

  def publish_button
    if object.may_publish?
      h.link_to "Publish", h.campaign_publishings_path(object),
                  method: :post,
                  data:   {confirm: "Are you sure you want to publish?"},
                  class:  "btn btn-primary"
    end
  end



  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
