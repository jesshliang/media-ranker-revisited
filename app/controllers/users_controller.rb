class UsersController < ApplicationController
  before_action :require_login, except: [:create]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])

    if user
      
      flash[:success] = "Welcome back, #{user.username}!"
    else
      user = User.build_from_github(auth_hash)

      if user.save
        flash[:success] = "Welcome to Media Ranker, #{user.username}!"
      else
        flash[:error] = "User account could not be created: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
    return
  end
end
