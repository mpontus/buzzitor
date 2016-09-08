require 'rails_helper';
require 'support/test_app';

describe SchedulingJob do
  include ActiveJob::TestHelper

  before do
    TestApp.boot do |server, app|
      @server = server
      @app = app
    end
  end

  it "schedules FetchJob for outdated contexts" do
    @context = Monitoring::Context.create!(
      url: "http://#{@server.host}:#{@server.port}/"
    )
    FetchJob.perform_now(@context)

    expect {
      SchedulingJob.perform_now
    }.not_to have_enqueued_job

    interval = APP_CONFIG['fetch_interval'] || 60
    Timecop.travel(interval.seconds.from_now) do
      expect {
        $stderr.puts Time.now
        SchedulingJob.perform_now
      }.to have_enqueued_job(FetchJob).with(@context)
    end
  end
end
