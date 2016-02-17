require 'percentage'
require 'percent/hooks'

module Percent
end

if defined? Rails
  require 'percent/railtie'
end
