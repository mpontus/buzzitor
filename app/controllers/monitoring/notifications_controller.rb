class Monitoring::NotificationsController < ApplicationController
  def index
    @notifications = Monitoring::Notification.where(
      endpoint: params[:endpoint],
      fetched: false
    )

    render json: @notifications

    @notifications.update_all(
      fetched: true
    )
  end
end
