module Percent
  class Railtie < ::Rails::Railtie
    initializer 'percent.initialize' do
      Percent::Hooks.init
    end
  end
end
