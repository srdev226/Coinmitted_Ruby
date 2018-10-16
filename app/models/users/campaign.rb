class Users::Campaign < ApplicationRecord
  has_secure_token :referal_token
  belongs_to :user

  def url
    [
      Rails.application.routes.url_helpers.new_user_registration_url(only_path: true),
      '/',
      self.referal_token
    ].join
  end
end
