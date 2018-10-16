module API
  module V1
    class Passwords < Grape::API
      include API::V1::Defaults

      resource :passwords do
        desc 'Signup API'
        params do
          requires :email, type: String, desc: 'Email of User'
        end
        post '/', root: :passwords do
          user = User.where('lower(email) = ?', params[:email].downcase).limit(1)[0]
          if user.present?
            user.send_reset_password_instructions
            render success: 'Reset Password instructions sent.'
          else
            render error: 'No user with this email present.'
          end
        end

        desc 'Password update API', headers: Base.headers_definition
        params do
          requires :current_password, type: String, desc: 'Password of User'
          requires :password, type: String, desc: 'New Password of User'
        end
        patch '/password', root: :users do
          authenticate!
          if current_user.valid_password?(params[:current_password])
            current_user.update password: params[:password], password_confirmation: params[:password]
            render success: 'Password successfully updated.'
          else
            render error: 'Invalid password. Please try again.'
          end
        end
      end
    end
  end
end
