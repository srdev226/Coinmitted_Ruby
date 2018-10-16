module ControllerMacros
  #def login_admin
    #before(:each) do
      #@request.env["devise.mapping"] = Devise.mappings[:admin]
      #sign_in FactoryBot.create(:admin) # Using factory girl as an example
    #end
  #end
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end

  def login_with_user(user)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      #user = FactoryBot.create(:user)
      #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end

  def sign_in(user = double('user'), scope = :user)
    current_user = "current_#{scope}".to_sym
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end
