print "Using in memory SQLite 3\n"
require 'logger'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => ':memory:')
load File.dirname(__FILE__) + "/fixtures/schema.rb"
require File.dirname(__FILE__) + '/../db/00x_add_urlnames_table.rb'
AddUrlnamesTable.up