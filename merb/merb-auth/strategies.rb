# This file is specifically for you to define your strategies 
#
# You should declare you strategies directly and/or use 
# Merb::Authentication.activate!(:label_of_strategy)
#
# To load and set the order of strategy processing

Merb::Slices::config[:"merb-auth-slice-password"][:no_default_strategies] = true

Merb::Authentication.activate!(:default_password_form)
#Merb::Authentication.activate!(:default_basic_auth)

#class Md5Strategy < Merb::Authentication::Strategy
#  def run!
#    Merb.logger.debug "QQQ14: Attempting to authenticate"
#    if request.params[login_param] && request.params[password_param]
#          Merb.logger.debug "QQQ14: User is request.params[login_param], password is request.params[password_param]"
#      user = user_class.authenticate(request.params[login_param], request.params[password_param])
#      if !user
#        request.session.authentication.errors.clear!
#        request.session.authentication.errors.add(login_param, strategy_error_message)
#      end
#      user
#    end
#  end
#
#  def strategy_error_message
#           "#{login_param.to_s.capitalize} or #{password_param.to_s.capitalize} were incorrect"
#  end
#end
