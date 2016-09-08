require 'rails_helper'
require 'support/wait_helper'

RSpec.feature "Notifier", js: true do
  include ActiveJob::TestHelper

  before do
    stub_request(:any, /example.org/)
      .to_return body: <<-HTML
                   <h1>Hello world!</h1>
                 HTML
  end

  it "should dispatch welcoming notification" do
    @count = Rpush::Notification.all.count

    perform_enqueued_jobs do
      visit '/monitoring/contexts/new'
      fill_in "Url", with: "http://example.org/"
      click_button "Create Context"
    end

    @result = WaitHelper.wait_until(2) do
      Rpush::Notification.all.count == @count +1
    end
    assert @result
  end

  it "should dispatch update notifications" do
    @count = Rpush::Notification.all.count

    perform_enqueued_jobs do
      visit '/monitoring/contexts/new'
      fill_in "Url", with: "http://example.org/"
      click_button "Create Context"
    end

    assert (WaitHelper.wait_until(2) do
      Rpush::Notification.all.count == @count +1
    end)

    stub_request(:any, /example.org/)
      .to_return body: <<-HTML
                     <h1>Foo Bar!</h1>
                   HTML

    FetchJob.perform_now(Monitoring::Context.last)

    assert (WaitHelper.wait_until(2) do
      Rpush::Notification.all.count == @count +2
    end)

  end

end
