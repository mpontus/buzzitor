class CoreController < ApplicationController
  protect_from_forgery :except => :serviceworker

  layout false

  def homepage
  end

  def redirect
    if params[:to]
      redirect_to params[:to]
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
