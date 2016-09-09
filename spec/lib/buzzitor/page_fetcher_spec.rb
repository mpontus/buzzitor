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
    content = nil
    Buzzitor::PageFetcher::fetch(@test_app_url) do |driver|
      content = driver.html
    end
    content
  end

  it "fetches remote content" do
    @app.content = 'Foobar';
    expect(subject).to include("Foobar")
  end

  it "evaluates javascript on fetched page" do
    @app.content = '<script>document.write("foo"+"bar");</script>';
    expect(subject).to include("foobar")
  end

  it "doesn't stumble on javascript errors" do
    @app.content = '<script>document.write("Foo"+"Bar"); throw "Error";</script>';
    expect(subject).to include("FooBar")
  end

end
