class Monitoring::Context < ApplicationRecord

  has_many :results
  has_many :subscribers

  after_create_commit do
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
  end

  def fetch!
    result = fetch
    self.results << Monitoring::Result.new(content: result[:content])
    save!
  end

  def self.batch_processing
    Monitoring::Context.where("endpoint IS NOT NULL AND fetched_at < :threshold",
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
