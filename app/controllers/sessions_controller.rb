class SessionsController < ApplicationController

    def destroy
        session.delete :user_id

        redirect_to '/'
    end

    def new
        @user = User.new
        render layout: "welcome"
    end

    def facebook_login
        @user = User.find_or_create_by(uid: auth['uid']) do |u|
            u.name = auth['info']['name']
            u.username = auth['info']['email']
            u.uid = auth['uid']
            u.password = 'Temporary'
        end
        session[:user_id] = @user.id
        redirect_to '/'
    end

    def create 
        @user = User.find_by(username: params[:user][:username])

        if @user.authenticate(params[:user][:password]) 
            session[:user_id] = @user.id

            redirect_to '/'
        else
            flash[:alert] = "Could not authenticate your account"
            render :new
        end
        
    end

    private

    def auth
        request.env['omniauth.auth']
    end

end