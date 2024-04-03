# frozen_string_literal: true

class MasterUsers::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
    p '######### master new'
  end

  # POST /resource/sign_in
  def create
    super
    p '######### master create'
  end

  # DELETE /resource/sign_out
  def destroy
    p '######### master destroy'
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
