class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def line
    basic_action
  end

  private
  
  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = User.find_by(uid: @omniauth['uid'])
      return if @profile.nil?

      @profile.set_values(@omniauth)
      sign_in(:user, @profile)
    end
    redirect_to root_path
  end
end
