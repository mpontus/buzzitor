require 'sinatra/base'

class TestApp < Sinatra::Base
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
