class UsersController < ApplicationController
  
  def setup
    @user = User.new(name: "Example user", email: "user@gmail.com")
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end
end
