class CoreController < ApplicationController
  protect_from_forgery :except => :serviceworker

  layout false

  def homepage
  end

  def proxy
    if params[:to]
      render inline: URI.parse(params[:to]).read, content_type: 'text/css'
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
