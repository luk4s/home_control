class HomesController < ApplicationController
  before_action :login_require

  def new
    @home = current_user.build_home
  end

  def create
    @home = current_user.build_home entity_attributes
    respond_to do |format|
      if @home.save
        format.html { redirect_to home_path }
      else
        render :new
      end
    end
  end

  def show
    @home = current_user.home
    return redirect_to new_home_path unless @home

    respond_to do |format|
      format.html
      format.json { render json: @home.duplex }
    end
  end

  def edit
  end

  def update
  end

  private

  def entity_attributes
    params.require(:home).permit(:atrea_login, :atrea_password)
  end
end
