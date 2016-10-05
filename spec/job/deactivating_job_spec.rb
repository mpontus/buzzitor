require 'rails_helper';
require 'support/fake_host';

describe DeactivatingJob do
  include ActiveJob::TestHelper

  it "deactivates obsolete contexts" do
    @context = Monitoring::Context.create!(
      url: "http://example.org/"
    )
    @context.update(visited_at: Time.now)

    expect {
      DeactivatingJob.perform_now
      @context.reload
    }.not_to change(@context, :active)

    interval = APP_CONFIG['deactivation_interval'] || 3600
    Timecop.travel(interval.seconds.from_now) do
      expect {
        DeactivatingJob.perform_now
        @context.reload
      }.to change(@context, :active)
    end
  end
end
