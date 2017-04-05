require_dependency "yellin/application_controller"

module Yellin
  class AccountActivationsController < ApplicationController
    def edit
      @user = Yellin.user_class.find_by(email: params[:email])
      if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
        @user.activate
        log_in @user
        flash[:success] = "Account activated!"
        after_activate
      else
        flash[:danger] = "Invalid activation link"
        redirect_to main_app.root_url
      end
    end

    def after_activate
      begin
        redirect_to @user
      rescue NoMethodError
        redirect_to main_app.root_url
      end
    end
  end
end