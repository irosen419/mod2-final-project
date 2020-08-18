class UsersController < ApplicationController
    before_action :find_user, except: [:index, :new, :create]
    skip_before_action :authorized, only: [:new, :create]

    def index
        @users = User.search(params[:query])
        render :index
    end

    def show
        @users = User.all
    end

    def new
        @user = User.new
    end

    def create
        @user = User.create(user_params)
        if @user.valid?
            session[:user_id] = @user.id
            redirect_to posts_path
        else
            render :new
        end
    end

    def update
        @user.update(user_params)
        if @user.valid?
            redirect_to user_path(@user)
        else
            render :edit
        end
    end

    def destroy
        @user.destroy
        redirect_to new_user_path
    end

    private

    def user_params
        params.require(:user).permit(:username, :password, :query)
    end

    def find_user
        @user = User.find(params[:id])
    end
end
