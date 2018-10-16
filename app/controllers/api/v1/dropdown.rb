module API
  module V1
    class Dropdown < Grape::API
      include API::V1::Defaults

      resource :dropdown do

        desc 'Currency dropdown API', headers: Base.headers_definition
        get '/currency', root: :dropdown do
          authenticate!
          render Currency::CURRENCIES
        end
      end
    end
  end
end
