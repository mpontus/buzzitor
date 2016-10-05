require 'rufus-scheduler'

if Rails.env != 'test'
  scheduler = Rufus::Scheduler::singleton

  scheduler.every '5s', overlap: false do
    ActiveRecord::Base.connection_pool.with_connection do
      SchedulingJob.perform_now
    end
  end

  scheduler.every '5s', overlap: false do
    ActiveRecord::Base.connection_pool.with_connection do
      DeactivatingJob.perform_now
    end
  end

end
