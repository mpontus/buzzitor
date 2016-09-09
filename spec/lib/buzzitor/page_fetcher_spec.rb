require 'rails_helper'
require 'support/test_app';

RSpec.describe Buzzitor::PageFetcher do

  before do
    TestApp.boot do |server, app|
      @server, @app = server, app
    end
    @test_app_url = "http://#{@server.host}:#{@server.port}/";
  end

  subject do
    proc do
      content = nil
      Buzzitor::PageFetcher::fetch(@test_app_url) do |driver|
        content = driver.html
      end
      content
    end
  end

  it "fetches remote content" do
    @app.content = 'Foobar';
    expect(subject.call).to include("Foobar")
  end

  it "evaluates javascript on fetched page" do
    @app.content = '<script>document.write("foo"+"bar");</script>';
    expect(subject.call).to include("foobar")
  end

  it "doesn't stumble on javascript errors" do
    @app.content = '<script>throw "Error";</script> FooBar';
    expect(subject.call).to include("FooBar")
  end

end
