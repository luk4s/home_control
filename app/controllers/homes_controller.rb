class HomesController < ApplicationController
  before_action :login_require
  before_action :home, except: %i[new create]

  skip_forgery_protection if: -> { request.format.json? }, only: %i[scenario]

  def show
    return redirect_to new_home_path unless home

    ReadDuplexJob.perform_later(home)
    respond_to do |format|
      format.html
      format.json { render json: home.duplex }
    end
  end

  def new
    raise ArgumentError, "you already have a home!" if current_user.home

    @home = current_user.build_home
  end

  def edit
    # render "edit"
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

  def history
    return render_404 if (influxdb = Rails.application.credentials[:influxdb]).blank?

    client = InfluxDB2::Client.new(influxdb[:url], influxdb[:token], {
      precision: InfluxDB2::WritePrecision::SECOND,
    }.reverse_merge(influxdb))
    query_api = client.create_query_api
    query = "from(bucket: \"home.luk4s.cz\") |> range(start: -6h, stop: now()) " \
            "|> filter(fn: (r) => r._measurement == \"#{home.influxdb_id}\")" \
            "|> filter(fn: (r) => r._field == \"power\")" \
            "|> group(columns: [\"_field\"])" \
            "|> aggregateWindow(every: 1m, fn: last, createEmpty: false)" \
            "|> yield(name: \"last\")"
    result = query_api.query(query:)
    @data = result.values.flatten.map(&:records).flatten.sort_by(&:time).collect do |i|
      { x: Time.zone.parse(i.time).strftime("%H:%M"), y: i.value }
    end
    render json: @data
  end

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
    if (home.scenario = params.require(:scenario)) == "manual"
      home.manual_control!(mode: params.require(:mode), power: params.require(:power).to_i)
    end
    ReadDuplexJob.set(wait: 5.seconds).perform_later(home)
    ReadDuplexJob.set(wait: 10.seconds).perform_later(home)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: home.duplex }
    end
  end

  def reset
    home.update duplex_auth_token: nil
    ReadDuplexJob.perform_now(home)
    redirect_to home
  end

  private

  def entity_attributes
    duplex_attributes = %i[atrea_login atrea_password login_in_progress]
    influx_attributes = %i[influxdb_url influxdb_token influxdb_org influxdb_bucket]
    params.require(:home).permit(*(duplex_attributes + influx_attributes))
  end

  def home
    @home ||= current_user.home || redirect_to(action: "new")
  end

end
