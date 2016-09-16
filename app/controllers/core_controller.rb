class CoreController < ApplicationController
  protect_from_forgery :except => :serviceworker

  layout false

  def homepage
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

  def letsencrypt
    render text: 'tV5QuMB7r3YItpkHDs882uwGd_Wf-W3bhy4DobY_5Ww.iOyqJ4NTbpqXdsH4de834HMr2klY_oVbJaKqDc_Wolc'
  end
end
