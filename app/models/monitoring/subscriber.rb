class Monitoring::Subscriber < ApplicationRecord
  belongs_to :context

  after_create_commit do
    unless context.results.empty? then
      notify_initial
    end
  end

  def notify_initial
    notify "Monitoring has started!"
  end

  def notify(message="Website updated!")
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
    Rpush.push # TODO: Async
  end
end
