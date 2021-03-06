class Monitoring::SubscribersController < ApplicationController
  before_action :set_context

  def create
    @subscriber = @context.subscribers.find_or_initialize_by(
      endpoint: params[:subscription][:endpoint]
    )
    @subscriber.keys = params[:subscription][:keys]
    respond_to do |format|
      if @subscriber.save then
        format.html { redirect_to @context, notice: "Subscription successful." }
        format.json { render json: @context }
      else
        format.html { render template: 'monitoring/contexts/show' }
        format.json { render json: @subscriber.errors, status: :unprocessable_entry }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_context
      @context = Monitoring::Context.find(params[:context_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscriber_params
      params.require(:subscription).permit(:endpoint, :keys)
    end
end
