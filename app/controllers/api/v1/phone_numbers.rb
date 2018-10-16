module API
  module V1
    class PhoneNumbers < Grape::API
      include API::V1::Defaults

      resource :phone_numbers do
        desc 'Get Phone numbers API', headers: Base.headers_definition
        get '/', root: :phone_numbers do
          authenticate!
          phone_numbers = PhoneNumber.where(profile_id: current_user.profile.id)
          render phone_numbers: phone_numbers.map { |p| { id: p.id, hidden_number: p.hidden_number, verified: p.verified, full_number: p.full_number } }
        end

        desc 'Create Phone numbers API', headers: Base.headers_definition
        post '/', root: :phone_numbers do
          authenticate!
          fn = params[:full_phone].gsub(/^\+\d+?(?=\+)/,'')
          code = 5.times.map { rand(1..9) }.join

          phone_number = PhoneNumber.create(number: params[:number],
                                            verified: false,
                                            profile_id: current_user.profile.id,
                                            deleted: false,
                                            verification_code: code,
                                            full_number: fn)
          if phone_number.errors.blank?
            client = Twilio::REST::Client.new

            begin
              client.api.account.messages.create(
                  from: Rails.application.credentials.twilio_phone_number,
                  to: phone_number.full_number,
                  body: "Coinmitted verification code: #{code}"
              )
            rescue StandardError => e
              error = "Wrong number format, please check your phone number and try again. Error: #{e}"
            end
            if error.blank?
              phone_numbers = PhoneNumber.where(profile_id: current_user.profile.id)
              json = phone_numbers.map { |p| { id: p.id, hidden_number: p.hidden_number, verified: p.verified, full_number: p.full_number } }
              render phone_numbers: json
            else
              phone_number.destroy
              render error: error
            end
          else
            render error: phone_number.errors.full_messages.first
          end
        end

        desc 'Update Phone numbers API', headers: Base.headers_definition
        patch '/:id', root: :phone_numbers do
          authenticate!
          phone_number = PhoneNumber.where(id: params[:id], profile_id: current_user.profile.id).first
          if phone_number.present?
            fn = params[:full_phone].gsub(/^\+\d+?(?=\+)/,'')
            phone_number.update(number: params[:number], verified: false, full_number: fn)
            if phone_number.errors.blank?
              phone_numbers = PhoneNumber.where(profile_id: current_user.profile.id)
              render phone_numbers: phone_numbers.map { |p| { id: p.id, hidden_number: p.hidden_number, verified: p.verified, full_number: p.full_number } }
            else
              render error: phone_number.errors.full_messages.first
            end
          else
            render error: 'Phone number not present'
          end
        end

        desc 'Delete Phone number API', headers: Base.headers_definition
        delete '/:id', root: :phone_numbers do
          authenticate!
          phone_number = PhoneNumber.where(id: params[:id], profile_id: current_user.profile.id).first
          if phone_number.present?
            phone_number.destroy
            phone_numbers = PhoneNumber.where(profile_id: current_user.profile.id)
            render phone_numbers: phone_numbers.map { |p| { id: p.id, hidden_number: p.hidden_number, verified: p.verified, full_number: p.full_number } }
          else
            render error: 'Phone number not present'
          end
        end

        desc 'Verify Phone number API', headers: Base.headers_definition
        post '/:id/verify', root: :phone_numbers do
          authenticate!
          begin
            number = PhoneNumber.where(id: params[:id], profile_id: current_user.profile.id).first
          rescue StandardError => e
            error = "Error: #{e}"
          end
          if error.blank?
            if params[:code].to_s === number.decrypt_code.to_s
              number.update(verified: true)
              phone_numbers = PhoneNumber.where(profile_id: current_user.profile.id)
              render phone_numbers: phone_numbers.map { |p| { id: p.id, hidden_number: p.hidden_number, verified: p.verified, full_number: p.full_number } }
            else
              render error: "Wrong code"
            end
          else
            render error: error
          end
        end

        desc 'Send Verification code API', headers: Base.headers_definition
        post '/:id/verification_code', root: :phone_numbers do
          authenticate!
          begin
            number = PhoneNumber.where(id: params[:id], profile_id: current_user.profile.id).first
          rescue StandardError => e
            error = "Error: #{e}"
          end
          if error.blank?
            code = 5.times.map { rand(1..9) }.join

            number.update(verification_code: code)
            client = Twilio::REST::Client.new

            begin
              client.api.account.messages.create(
                  from: Rails.application.credentials.twilio_phone_number,
                  to: number.full_number,
                  body: "Coinmitted verification code: #{code}"
              )
            rescue StandardError => e
              error = "Wrong number format, please check your phone number and try again. Error: #{e}"
            end
            if error.blank?
              render success: 'Verification code sent.'
            else
              render error: error
            end
          else
            render error: error
          end
        end
      end
    end
  end
end
