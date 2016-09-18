require 'rails_helper';
require 'support/fake_host';

describe SchedulingJob do
  include ActiveJob::TestHelper

  setup do
    @fake_host = FakeHost.new do
      get '/' do
      end
    end
  end

  teardown do
    @fake_host.shutdown
  end

  it "schedules FetchJob for outdated contexts" do
    @context = Monitoring::Context.create!(
      url: @fake_host.base_url
    )
    FetchJob.perform_now(@context)

    expect {
      SchedulingJob.perform_now
    }.not_to change(@context, :fetched_at)

    interval = APP_CONFIG['fetch_interval'] || 60
    Timecop.travel(interval.seconds.from_now) do
      expect {
        SchedulingJob.perform_now
      }.to change(@context.reload, :fetched_at)
    end
  end
end
