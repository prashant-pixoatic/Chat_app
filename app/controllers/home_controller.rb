class HomeController < ApplicationController
  
  def index
    @groups = current_user.groups
    @users = User.all
  end
end
