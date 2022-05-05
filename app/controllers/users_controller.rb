class UsersController < ApplicationController
    def create
        user = User.create(user_params)
        if user.valid?
        session[:user_id] = user.id
        render json: user, status: :created
        else
            render json: {errors: user.errors}, status: :unprocessable_entity
        end
    end

    def show
        user = User.find(session[:user_id])
        if user
            render json: user
        else
            render json: {error: 'Not authorized'}, status: :unauthorized
        end
    rescue ActiveRecord::RecordNotFound
        render json: {error: 'No user id present'}, status: 401
    end

    private
    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
end
