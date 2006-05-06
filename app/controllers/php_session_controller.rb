class PhpSessionController < ApplicationController

  def setup_authorize_hash
    @authorization = { 
      "has_session"   => proc { true }
    }
  end

  def has_session
  end

  def setup_page_vars
    @breadcrumbs = 'Bleah! Bleah! Bleah!'
  end

end
