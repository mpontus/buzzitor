class CoreController < ApplicationController
  protect_from_forgery :except => :serviceworker

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
