class Monitoring < ApplicationRecord

  alias_attribute :url, :address_url
  alias_attribute :endpoint, :subscriber_endpoint

  after_create do
    FetchJob.perform_later self
  end

  # before_save do
  #   if content_changed? or error_changed? then
  #     self.fetched_at = Time.now
  #   end
  # end

  def fetch
    { content: Net::HTTP.get(URI(url)),
      error: nil }
  rescue => e
    byebug
  end

  def fetch!
    update_attributes self.fetch
  end

  def self.batch_processing
    Monitoring.where("endpoint IS NOT NULL AND fetched_at < :threshold",
                     { threshold: 1.seconds.ago })
      .order(fetched_at: :asc)
      .all.each do |monitoring|
      content = Net::HTTP.get(URI(monitoring.url))
      if monitoring.content != content
        monitoring.notify_subscriber
      end
      monitoring.update_attribute content: content
    end
  end

  def notify_subscriber
    return if endpoint.nil?
    registration_id = File.basename(URI(endpoint).path)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.where(name: "android_app").first #find_by_name("android_app")
    n.registration_ids = [ registration_id ]
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
