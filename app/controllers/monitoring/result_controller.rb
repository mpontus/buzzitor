class Monitoring::ResultsController < ApplicationController
  def show
    render html: @monitoring_result.content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitoring
      @monitoring_result = Monitoring::Result.find(params[:id])
    end
end
