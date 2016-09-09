class Monitoring::ContextsController < ApplicationController
  before_action :set_context, only: [:show, :edit, :update, :destroy]

  # GET /monitorings/1
  # GET /monitorings/1.json
  def show
  end

  # GET /monitorings/new
  def new
    @context = Monitoring::Context.new
  end

  # POST /monitorings
  # POST /monitorings.json
  def create
    @context = Monitoring::Context.new(monitoring_params)

    respond_to do |format|
      if @context.save
        format.html { redirect_to @context, notice: 'Monitoring was successfully created.' }
        format.json { render :show, status: :created, location: @context }
      else
        format.html { render :new }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_context
      @context = Monitoring::Context.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monitoring_params
      params.require(:monitoring_context).permit(:url)
    end
end
