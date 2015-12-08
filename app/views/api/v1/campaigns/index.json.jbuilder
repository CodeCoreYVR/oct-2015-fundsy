json.array! @campaigns do |campaign|
  json.id    campaign.id
  json.title campaign.capitalized_title # coming from the decorator
  json.url   campaign_url(campaign)
  json.rewards campaign.rewards do |reward|
    json.amount reward.amount
    json.body   reward.body
  end
end
