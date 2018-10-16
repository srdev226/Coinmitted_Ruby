class Campaign < ApplicationRecord
  belongs_to :affiliate, class_name: "User"
  has_secure_token :referal_token
  
  
  def url
    [
      Rails.application.routes.url_helpers.new_user_registration_url(only_path: true),
      '/',
      self.referal_token
    ].join
  end
  
end
