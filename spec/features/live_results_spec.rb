require 'integration_helper'
require 'support/fake_host'

RSpec.feature "Live results", js: true do
  setup do
    @fake_host = FakeHost.new do
      get "/" do
        "Hello world!"
      end
    end
  end

  teardown do
    @fake_host.shutdown
  end

  before do
    visit '/'
    fill_in "Url", with: @fake_host.base_url
    find(:fillable_field, "Url").native.send_keys(:return)
  end

  it "displays most recently fetched page" do
    expect(page).to have_selector 'iframe'
    within_frame 0 do
      expect(page).to have_content "Hello world!"
    end
  end

  describe "updates" do

    before do
      @fake_host.configure do
        get '/' do
          "Foo Bar"
        end
      end
    end

    it "displays the contents of updated webpage" do
      expect(page).to have_selector 'iframe'

      within_frame 0 do
        expect(page).to have_content 'Foo Bar'
      end
    end
  end

  describe "erroneous results" do

    before do
      @fake_host.configure do
        get '/' do
          sleep 5
          "Hello world!"
        end
      end
      @original_timeout = APP_CONFIG['page_fetcher_timeout']
      APP_CONFIG['page_fetcher_timeout'] = 0
    end

    after do
      APP_CONFIG['page_fetcher_timeout'] = @original_timeout
    end

    before do
      visit "/"
      fill_in "Url", with: @fake_host.base_url
      find(:fillable_field, "Url").native.send_keys(:return)
    end

    it "displays the error" do
      using_wait_time 50 do
        expect(page).to have_selector(".result .error")
      end
    end
  end
end
