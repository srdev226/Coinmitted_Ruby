class User < ApplicationRecord

  enum role: [:user, :admin, :investor, :affiliate]

  after_initialize :set_default_role, :if => :new_record?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :two_factor_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
           

  has_many :investments, dependent: :destroy

  # merged with affiliated app
  #has_many :users_investments, class_name: 'User::Investment'
  has_many :affiliations
  has_many :campaigns
  has_many :affiliates, through: :affiliations
  belongs_to :affiliate, class_name: 'User', optional: true

  #has_many :saved_investments
  has_many :earnings, dependent: :destroy
  has_many :payouts, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_one :profile, dependent: :destroy

  has_many :devices, dependent: :destroy

  #validates :password, presence: true, :on => :update, :unless = lambda{ |user| user.password.blank? }
  validates :password_confirmation, presence: true, :on => :update, :unless => lambda{ |user| user.password.blank? }

  has_secure_token :affiliate_token

  accepts_nested_attributes_for :profile

  has_one_time_password(encrypted: true)

  def profile
     super || build_profile
  end

  def send_two_factor_authentication_code(direct_otp)
    profile = Profile.where(user_id: self.id).first
    number = PhoneNumber.where(profile_id: profile.id, verified: true).first

    client = Twilio::REST::Client.new
    begin
      client.api.account.messages.create(
        from: Rails.application.credentials.twilio_phone_number,
        to: profile.full_number,
        body: "Coinmitted verification code: #{direct_otp}"
      )
      return true
    rescue Exception => e
      return e.message
    end
  end

  def need_two_factor_authentication?(request)
    enable_two_factor?
  end

  # update a new profile after confirmation
  def after_confirmation
    get_profile = self.profile
    if get_profile.present? && (get_profile.deleted == nil && get_profile.membership == nil)
      profile_params = { bio: "Coinmitted investor", language: "en", deleted: false, membership: 0 }
      get_profile.update_attributes(profile_params)
    end
  end

  def set_default_role
    self.role ||= :user
  end

  # @return collection of users with investments status active
  def total_investment
    self.affiliates.joins(:investments).where(investments: {status: 'active',status: 'ended'})
  end

  def investment_by_affiliates
    total_investment
  end

  def affiliates_with_investments
    #total_investment
    self.affiliates.joins(:investments).where(investments: {status: 'active'})
    #self.affiliates.where.not(affiliations: { investment_id: nil})
  end

  def affiliates_without_investments
    total_investment
    #self.affiliates.joins(:investments).where.not(investments: {status: 'active', status: 'ended'})
  end

  def update_affiliate_link_visits
    self.increment!(:affiliate_link_visits)
  end

  def affiliate_level
    affiliate_levels = AffiliateLevel.all
    affiliate_levels.select do |affiliate_level|
      affiliate_level.range.include?(self.affiliates.count)
    end.first
  end

  def conversions
    if affiliate_link_visits == 0 || affiliates.count == 0
      0
    else
      self.affiliate_link_visits.to_f / self.affiliates.count
    end
  end

end
