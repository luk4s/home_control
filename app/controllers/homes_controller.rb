class HomesController < ApplicationController
  before_action :login_require
  before_action :home, except: %i[new create]

  def new
    raise ArgumentError, "you already have a home!" if current_user.home

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
    return redirect_to new_home_path unless home

    ReadDuplexJob.perform_later(home)
    respond_to do |format|
      format.html
      format.json { render json: home.duplex }
    end
  end

  def edit; end

  def update
    home_attributes = entity_attributes
    home_attributes.delete(:atrea_password) if entity_attributes[:atrea_password].blank?
    home.update home_attributes
    ReadDuplexJob.set(wait: 10.seconds).perform_later(home)
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: home.duplex }
    end
  end

  # Set prepared scenario of duplex
  def scenario
    home.scenario = params.require(:scenario)
    ReadDuplexJob.perform_later(home)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: home.duplex }
    end
  end

  def somfy_authorize
    redirect_to @home.somfy.authorize(self)
  end

  def somfy
    begin
      response = @home.somfy.get_code(params.require(:code), self)
      @home.update(somfy_token: response.token, somfy_refresh_token: response.refresh_token)
      return render plain: "Somfy paired!"
    rescue OAuth2::Error => e
      flash[:error] = e.message
    end

    render :show
  end

  private

  def entity_attributes
    duplex_attributes = %i[atrea_login atrea_password login_in_progress]
    somfy_attributes = %i[somfy_client_id somfy_secret]
    influx_attributes = %i[influxdb_url influxdb_token influxdb_org influxdb_bucket]
    params.require(:home).permit(*(duplex_attributes + somfy_attributes + influx_attributes))
  end

  def home
    @home ||= current_user.home
  end

end
