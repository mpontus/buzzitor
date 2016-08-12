class MonitoringsController < ApplicationController
  before_action :set_monitoring, only: [:show, :edit, :update, :destroy]

  # GET /monitorings/1
  # GET /monitorings/1.json
  def show
  end

  # GET /monitorings/new
  def new
    @monitoring = Monitoring.new
  end

  # POST /monitorings
  # POST /monitorings.json
  def create
    @monitoring = Monitoring.new(monitoring_params)

    respond_to do |format|
      if @monitoring.save
        format.html { redirect_to @monitoring, notice: 'Monitoring was successfully created.' }
        format.json { render :show, status: :created, location: @monitoring }
      else
        format.html { render :new }
        format.json { render json: @monitoring.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitoring
      @monitoring = Monitoring.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monitoring_params
      params.require(:monitoring).permit(:url)
    end
end
