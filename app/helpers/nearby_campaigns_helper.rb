module NearbyCampaignsHelper

  def campaigns_markers(campaigns)
    Gmaps4rails.build_markers(campaigns) do |campaign, marker|
      marker.lat        campaign.latitude
      marker.lng        campaign.longitude
      marker.infowindow campaign.title
    end
  end

end
