class CoreController < ApplicationController
  protect_from_forgery :except => :serviceworker

  layout false

  def homepage
  end

  def proxy
    if params[:to]
      self.response_body = Net:HTTP.get(URI(params[:to]))
    else
      redirect_to root_url
    end
  end

  def serviceworker
    respond_to do |format|
      format.js
    end
  end

  def manifest
    respond_to do |format|
      format.json
    end
  end
end
