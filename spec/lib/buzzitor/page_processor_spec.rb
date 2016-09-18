require 'rails_helper'

RSpec.describe Buzzitor::PageProcessor do

  let (:url) { "https://example.org/subdir/index.html" }

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
    expect(result).to include("https://example.org/foobar")
  end

  it "rewrites relative uri" do
    result = subject.call <<-HTML
      <img src="foo/bar" />
    HTML
    expect(result).to include("https://example.org/subdir/foo/bar")
  end

  it "adds a _target=\"blank\" attribute to hyperlinks" do
    result = subject.call <<-HTML
      <a href="https://foo.bar.org" />
    HTML
    expect(result).to include('target="_blank"');
  end

  it "processes protocol-relative urls" do
    result = subject.call <<-HTML
      <a href="//foo.bar.org">
    HTML
    expect(result).to include('href="https://foo.bar.org"')
  end

  it "processes invalid urls" do
    result = subject.call <<-HTML
      <a href=":/foo\#{bar: baz}">
    HTML
    expect(result).to include('#%7Bbar:%20baz%7D')
  end

  it "proxies addresses in 'head' through our redirect", :focus do
    result = subject.call <<-HTML
      <head>
        <link rel="stylesheet" href="http://example.org/somestylesheet">
      </head>
    HTML
    expect(result).to include('proxy?to=')
  end
end
