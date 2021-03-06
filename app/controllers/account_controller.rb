# coding: utf-8
class AccountController < Devise::RegistrationsController
  before_filter :authenticate_registerable!, :only => [:new, :create]

  def edit
    @user = current_user
  end

  def update_private_token
    current_user.update_private_token
    render :text => current_user.private_token
  end

  # POST /resource
  def create
    build_resource
    resource.login = params[resource_name][:login]
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def destroy
    resource.soft_delete
    sign_out_and_redirect("/login")
    set_flash_message :notice, :destroyed
  end

  private

    def authenticate_registerable!
      if not Setting.registerable
        redirect_to root_path, :notice => '论坛已关闭注册功能'
      end
    end
end
