class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :rewards, :comments

  def title
    decorated_object.capitalized_title
  end

  private

  def decorated_object
    object.decorate
  end
end
