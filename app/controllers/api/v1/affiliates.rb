module API
  module V1
    class Affiliates < Grape::API
      include API::V1::Defaults

      resource :affiliates do

        desc 'Currency dropdown API', headers: Base.headers_definition
        get '/', root: :affiliates do
          # authenticate!
          url = [ new_user_registration_url, '/', current_user.affiliate_token].join
          affiliate_levels = []
          affiliate_text = ''
          AffiliateLevel.all.each do |a|
            affiliate_levels << { name: a.name, range_end: a.range_end }
            if a == current_user.affiliate_level
              affiliate_text = "#{a.range_end - current_user.affiliates.count} Affiliates to #{a.next_level_name.upcase}"
            end
          end
          total_affiliates = current_user.affiliates.count
          affiliate_level = current_user.affiliate_level
          clicks = current_user.affiliate_link_visits
          signup = current_user.affiliates.count
          active_investors = current_user.affiliates_with_investments.count
          invested = affiliates_invested(current_user.total_investment)
          conversions = current_user.conversions
          total_earnings = affiliates_earned(current_user.investment_by_affiliates)
          progress = current_user.affiliate_level ? current_user.affiliates.count * affiliate_level.progress_step : 0
          users = []
          current_user.affiliates_with_investments.each do |user|
            users << {
                date: user.created_at.strftime("%F"),
                email: user.email,
                invested: user.total_investment,
                commission: user.total_investment * current_user.affiliate_level.commision,
                #TODO campaign source
                campaign_source: ''
            }
          end
          render affiliate_levels: affiliate_levels, affiliate_text: affiliate_text, total_affiliates: total_affiliates,
                 affiliate_level: affiliate_level, clicks: clicks, signup: signup, active_investors: active_investors,
                 invested: invested, conversions: conversions, total_earnings: total_earnings, users: users, url: url, progress: progress
        end
      end
    end
  end
end
