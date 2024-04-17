class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def line
    basic_action
  end

  private
  
  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth['provider'], uid: @omniauth['uid'])
      @profile.name = @omniauth['info']['name']
      @profile.image_url = @omniauth['info']['image']
      @profile.email = "#{@omniauth['uid']}@example.com"
      @profile.save!
      @profile.set_values(@omniauth)
      sign_in(:user, @profile)
    end
    redirect_to root_path
  end
end
