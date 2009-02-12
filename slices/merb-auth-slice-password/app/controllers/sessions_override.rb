class MerbAuthSlicePassword::Sessions < MerbAuthSlicePassword::Application

  after :redirect_after_login,  :only => :update, :if => lambda{ !(300..399).include?(status) }
  after :redirect_after_logout, :only => :destroy

  private
  # @overwritable
  def redirect_after_login
    message[:notice] = "Authenticated Successfully"
    root_url = "#{request.protocol}://#{request.host}/"
    redirect_back_or root_url, :message => message, :ignore => [slice_url(:login), slice_url(:logout)]
  end

  # @overwritable
  def redirect_after_logout
    message[:notice] = "Logged Out"
    root_url = "#{request.protocol}://#{request.host}/"
    redirect root_url, :message => message
  end

end
