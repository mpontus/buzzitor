require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '5s' do
  interval = 10
  Monitoring::Context
    .where('fetched_at < :before',
           { before: interval.seconds.ago })
    .each do |context|
    FetchJob.perform_later(context)
  end
end
