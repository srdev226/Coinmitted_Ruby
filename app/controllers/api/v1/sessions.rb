module API
  module V1
    class Sessions < Grape::API
      include API::V1::Defaults

      resource :sessions do
        desc 'Login API'
        params do
          requires :email, type: String, desc: 'Email of User'
          requires :password, type: String, desc: 'Password of User'
          requires :uuid, type: String, desc: 'Device Id'
        end
        post '/', root: :sessions do
          user = User.where('lower(email) = ?', params[:email].downcase).limit(1)[0]
          if user.present? and user.valid_password?(params[:password])
            device = user.devices.find_or_create_by uuid: params[:uuid]
            device.update os: (params[:os] || 'ios')
            render id: user.id,
                   email: user.email,
                   api_token: device.api_token
          else
            render error: 'Invalid email or password. Please try again.'
          end
        end


        desc 'Logout API'
        params do
          requires :uuid, type: String, desc: 'Device Id'
          requires :api_token, type: String, desc: 'API Token'
        end
        post '/logout', root: :users do
          device = Device.find_by(uuid: params[:uuid], api_token: params[:api_token])
          if device.present?
            device.destroy
          end
          render success: 'Successfully Logged out.'
        end
      end
    end
  end
end
