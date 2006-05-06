require 'pp'
require 'stringio'

module Kernel
  private
  def pp_s(*objs)
      s = StringIO.new
      objs.each {|obj|
        PP.pp(obj, s)
      }
      s.rewind
      s.read
  end
  module_function :pp_s
end