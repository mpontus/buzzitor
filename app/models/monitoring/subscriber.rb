class Monitoring::Subscriber < ApplicationRecord
  belongs_to :context

  after_create_commit do
    welcome unless context.results.empty?
  end

  def welcome
    notify "Monitoring has started!"
  end

  def update
    notify "Page has changed!"
  end

  def notify(message)
    registration_id = File.basename(URI(endpoint).path)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.where(name: "android_app").first #find_by_name("android_app")
    n.registration_ids = [ registration_id ]
    n.priority = 'high'
    n.content_available = true
    n.notification = {
      title: "Buzzitor",
      body: message,
    }
    n.save!
  end
end
