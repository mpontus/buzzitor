require 'rufus-scheduler'

if Rails.env != 'test'
  scheduler = Rufus::Scheduler::singleton

  scheduler.every '5s' do
    ActiveRecord::Base.connection_pool.with_connection do
      SchedulingJob.perform_now
    end
  end
end
