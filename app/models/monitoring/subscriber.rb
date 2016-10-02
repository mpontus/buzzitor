class Monitoring::Subscriber < ApplicationRecord
  belongs_to :context

  after_create_commit do
    welcome unless context.results.empty?
  end

  def welcome
    notify "Monitoring has begun!"
  end

  def update
    notify "Page was updated!"
  end

  def notify(body)
    params = {
      endpoint: endpoint,
      auth: keys["auth"],
      p256dh: keys["p256dh"],
      message: {
        id: context.id,
        title: context.results.last.title,
        body: body,
        icon: context.results.last.thumbnail.url
      }.to_json,
      api_key: ENV['BUZZITOR_GCM_PUBLIC_API_KEY']
    }
    Webpush.payload_send(params)
  rescue Webpush::InvalidSubscription
    destroy()
  end
end
