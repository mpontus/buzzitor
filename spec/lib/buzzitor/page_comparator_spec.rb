require 'rails_helper'

RSpec.describe Buzzitor::PageComparator do

  subject do
    -> (old, new, focus = nil) do
      if focus.nil?
        Buzzitor::PageComparator.compare(old, new)
      else
        Buzzitor::PageComparator.compare(old, new, focus)
      end
    end
  end

  it "compares page contents" do
    old = <<-HTML
      Hello world!
    HTML
    new = <<-HTML
      Foo Bar
    HTML
    result = subject.call(old, new);
    expect(result).to be_falsey
  end

  it "ignores changes to attributes" do
    old = '<div class="foo">Hello world!</div>'
    new = '<div class="bar">Hello world!</div>'
    result = subject.call(old, new);
    expect(result).to be_truthy
  end

end
