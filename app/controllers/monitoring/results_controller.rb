class Monitoring::ResultsController < ApplicationController
  before_action :set_result, only: [:show]

  def show
    render text: @result.content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @result = Monitoring::Result.find(params[:id])
    end
end
