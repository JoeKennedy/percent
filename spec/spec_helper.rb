require 'percent'
require 'active_record'
require 'bigdecimal'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: File.dirname(__FILE__) + '/percent.sqlite3')

Percent::Hooks.init

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'
# load File.dirname(__FILE__) + '/support/data.rb'
