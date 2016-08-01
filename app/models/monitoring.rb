class Monitoring < ApplicationRecord

  after_create do
    FetchJob.perform_later self
  end

  def fetch
    { content: Net::HTTP.get(URI(address)),
      error: nil }
  rescue => e
    byebug
  end

  def fetch!
    update_attributes self.fetch
  end

  def self.batch_processing
    Monitoring.where("endpoint IS NOT NULL AND fetched_at < :treshold",
                     { treshold: 30.seconds.ago })
      .order(fetched_at: :asc)
      .find_each do |monitoring|
      content = HTTP.get(monitoring.address)
      if monitoring.content != content
        monitoring.notify_subscriber
      end
      monitoring.update_attribute content: content
    end
  end

  def notify_subscriber
    if !Rpush::Gcm::App.where(name: "android_app").first #find_by_name("android_app")
      app = Rpush::Gcm::App.new
      app.name = "android_app"
      app.auth_key = "AIzaSyDBj_VRWQ66MP3VjulFopkPziVaBgwPkTw"
      app.connections = 1
      app.save!
    end

    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.where(name: "android_app").first #find_by_name("android_app")
    n.registration_ids = [ self.endpoint ]
    n.priority = 'high'
    n.content_available = true
    n.notification = {
      title: "Buzzitor",
      body: "Website updated!",
    }
    n.save!

    Rpush.push
  end


end
