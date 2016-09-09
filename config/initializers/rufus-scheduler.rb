require 'rufus-scheduler'

if Rails.env == 'production'
  scheduler = Rufus::Scheduler::singleton

  scheduler.every '5s' do
    SchedulingJob.perform_now
  end
end
