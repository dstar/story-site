class PhpSessionController < ApplicationController

  def has_session
  end

  def setup_page_vars
    @breadcrumbs = 'Bleah! Bleah! Bleah!'
  end

end
