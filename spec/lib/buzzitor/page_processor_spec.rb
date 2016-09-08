require 'rails_helper'

RSpec.describe Buzzitor::PageProcessor do

  let (:url) { "http://example.org/subdir/index.html" }

  subject do
    proc do |document|
      Buzzitor::PageProcessor.process(
        document,
        url
      )
    end
  end

  it "accepts nokogiri document" do
    subject.call(Nokogiri::HTML("foobar"))
  end

  it "accepts document contents as a string" do
    subject.call("foobar")
  end

  it "returns document contents" do
    result = subject.call("foobar")
    expect(result).to be_kind_of(String)
    expect(result).to include("foobar")
  end

  it "removes script tags from the document" do
    result = subject.call <<-HTML
      <script>document.write("Foo")</script>
    HTML
    expect(result).not_to include("Foo");
  end

  it "rewrites non-absolute uri" do
    result = subject.call <<-HTML
      <img src="/foobar" />
    HTML
    expect(result).to include("http://example.org/foobar")
  end

  it "rewrites relative uri" do
    result = subject.call <<-HTML
      <img src="foo/bar" />
    HTML
    expect(result).to include("http://example.org/subdir/foo/bar")
  end

  it "adds a _target=\"blank\" attribute to hyperlinks" do
    result = subject.call <<-HTML
      <a href="http://example.org" />
    HTML
    expect(result).to include('target="_blank"');
  end
end
