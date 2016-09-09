class Monitoring::Subscriber < ApplicationRecord
  belongs_to :context

  after_create_commit do
    welcome unless context.results.empty?
  end

  def welcome
    notify context.results.last.title, body: "Monitoring has begun"
  end

  def update
    notify context.results.last.title, body: "Page was updated"
  end

  def notify(title, options = {})
    params = {
      endpoint: endpoint,
      auth: keys["auth"],
      p256dh: keys["p256dh"],
      message: {
        title: title,
        body: options[:body],
      }.to_json,
      api_key: ENV['BUZZITOR_GCM_PUBLIC_API_KEY']
    }
    Webpush.payload_send(params)
  end
end
