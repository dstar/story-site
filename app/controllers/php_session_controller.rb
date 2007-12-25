class PhpSessionController < ApplicationController

  def setup_authorize_hash
    @authorization = {}
  end

  def check_authorization(user)
    return true #anyone can do this
  end  
  
  def has_session
  end

  def setup_page_vars
    @breadcrumbs = 'Bleah! Bleah! Bleah!'
  end

end
