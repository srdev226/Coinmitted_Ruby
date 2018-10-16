module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resource :users do
        desc 'Get Profile API', headers: Base.headers_definition
        get '/profile', root: :users do
          authenticate!
          profile = current_user.profile
          render id: current_user.id,
                 email: current_user.email,
                 name: profile.present? ? profile.name : '',
                 bio: profile.present? ? profile.bio : '',
                 currency: profile.present? ? profile.currency.upcase : 'USD',
                 gender: profile.present? ? profile.gender : 'USD',
                 two_factor_authentication: false
        end

        desc 'Profile Update Name API', headers: Base.headers_definition
        patch '/name', root: :users do
          authenticate!
          profile = current_user.profile
          if profile.update name: params[:name]
            render success: 'Name updated.'
          else
            render error: profile.errors.full_messages.first
          end
        end

        desc 'Profile Update Bio API', headers: Base.headers_definition
        patch '/bio', root: :users do
          authenticate!
          profile = current_user.profile
          if profile.update bio: params[:bio]
            render success: 'Bio updated.'
          else
            render error: profile.errors.full_messages.first
          end
        end

        desc 'Profile Update Gender API', headers: Base.headers_definition
        patch '/gender', root: :users do
          authenticate!
          profile = current_user.profile
          if profile.update gender: params[:gender]
            render success: 'Gender updated.'
          else
            render error: profile.errors.full_messages.first
          end
        end

        desc 'Profile Update Currency API', headers: Base.headers_definition
        patch '/currency', root: :users do
          authenticate!
          profile = current_user.profile
          if profile.update currency: params[:currency]
            render success: 'Currency updated.'
          else
            render error: profile.errors.full_messages.first
          end
        end

        desc 'Profile Update Email API', headers: Base.headers_definition
        patch '/email', root: :users do
          authenticate!
          if current_user.update email: params[:email]
            render success: 'Email updated.'
          else
            render error: current_user.errors.full_messages.first
          end
        end
      end
    end
  end
end
