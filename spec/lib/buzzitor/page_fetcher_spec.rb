require 'rails_helper'
require 'support/fake_host';

RSpec.describe Buzzitor::PageFetcher do

  before do
    @fake_host = FakeHost.new do
      get '/' do
      end
    end
  end

  subject do
    content = nil
    Buzzitor::PageFetcher::fetch(@fake_host.base_url) do |driver|
      content = driver.html
    end
    content
  end

  it "fetches remote content" do
    @fake_host.configure do
      get '/' do
        "Foobar"
      end
    end

    expect(subject).to include("Foobar")
  end

  it "evaluates javascript on fetched page" do
    @fake_host.configure do
      get '/' do
        '<script>document.write("foo"+"bar");</script>';
      end
    end

    expect(subject).to include("foobar")
  end

  it "doesn't stumble on javascript errors" do
    @fake_host.configure do
      get '/' do
        '<script>document.write("Foo"+"Bar"); throw "Error";</script>';
      end
    end

    expect(subject).to include("FooBar")
  end

end
