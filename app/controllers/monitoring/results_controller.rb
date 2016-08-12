class Monitoring::ResultsController < ApplicationController
  before_action :set_monitoring, only: [:show, :edit, :update, :destroy]

  def show
    render text: @monitoring_result.content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitoring
      @monitoring_result = Monitoring::Result.find(params[:id])
    end
end
