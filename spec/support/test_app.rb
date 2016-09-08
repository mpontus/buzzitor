require 'sinatra/base'

class TestApp < Sinatra::Base

  class << self
    def boot
      app = TestApp.new!
      server = Capybara::Server.new(app).boot
      yield server, app
    end
  end


  attr_accessor :content

  def initialize (app = nil)
    super()
    @content = ""
  end

  def content= (new_content)
    @content = new_content
  end

  get '/' do
    @content
  end
end
