class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :name, :affiliates_count, :earnings, :url
end
