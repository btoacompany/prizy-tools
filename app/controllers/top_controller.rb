#coding:utf-8

class TopController < ApplicationController
  before_filter :authenticate_user, :except => [:login, :login_complete, :logout, :forgot_password, :forgot_password_submit]
  before_filter :init_url

  def login
    if session[:id] || cookies[:id]
      redirect_to_index
    end
    reset_session
  end

  def login_complete
    authorized_user = Admin.authenticate(params[:email],params[:password])
    reset_session

    if authorized_user
      if authorized_user.delete_flag == 1
	reset_session
	flash[:notice] = "ユーザー名かパスワードに誤りがあります"
	render 'login', :status => :unauthorized
      else
	if params[:remember].to_i == 1 
	  cookies.permanent[:id] = authorized_user.id
	  cookies.permanent[:email] = authorized_user.email
	else
	  session[:id] = authorized_user.id
	  session[:email] = authorized_user.email
	end

	flash[:notice] = "" 

	redirect_to_index
      end
    else
      flash[:notice] = "ユーザー名かパスワードに誤りがあります"
      render 'login', :status => :unauthorized
    end
  end

  def logout
    session[:id] = nil
    session[:email] = nil
    cookies.delete :id
    cookies.delete :email
    reset_session

    redirect_page("top", "login") 
  end

  def forgot_password
  end

  def forgot_password_submit
    admin = Admin.where("email LIKE '#{params[:email]}' AND delete_flag = 0").first

    if admin.present?
      temp_password = SecureRandom.hex(4)
      admin.save_record({:password => temp_password})

      data = {
	:email	  => params[:email],
	:password => temp_password,
	:prizy_url  => @prizy_url
      }

      UserMailer.reset_password(data).deliver_later
      redirect_to_index 
    else
      flash[:notice] = "The email you entered does not exist"
      render 'forgot_password'
    end
  end

  def redirect_to_index
    redirect_page("analytics", "company")
  end
end
