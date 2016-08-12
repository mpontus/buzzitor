class Monitoring::ContextsController < ApplicationController
  before_action :set_monitoring, only: [:show, :edit, :update, :destroy]

  # GET /monitorings/1
  # GET /monitorings/1.json
  def show
  end

  # GET /monitorings/new
  def new
    @monitoring_context = Monitoring::Context.new
  end

  # POST /monitorings
  # POST /monitorings.json
  def create
    @monitoring_context = Monitoring::Context.new(monitoring_params)

    respond_to do |format|
      if @monitoring_context.save
        format.html { redirect_to @monitoring_context, notice: 'Monitoring was successfully created.' }
        format.json { render :show, status: :created, location: @monitoring_context }
      else
        format.html { render :new }
        format.json { render json: @monitoring_context.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitoring
      @monitoring_context = Monitoring::Context.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monitoring_params
      params.require(:monitoring_context).permit(:url)
    end
end
