require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'boot')
Rails::Initializer.run(:require_frameworks)
Rails::Initializer.run(:load_plugins)
$: << '../'
$: << '../lib/'
require File.dirname(__FILE__) + '/connection'
require 'test_help'

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"

class Test::Unit::TestCase #:nodoc:
  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end

  def self.require_fixture_classes(table_names=nil)
    (table_names || fixture_table_names).each do |table_name| 
      file_name = table_name.to_s
      file_name = file_name.singularize if ActiveRecord::Base.pluralize_table_names
      begin
        file_path = File.dirname(__FILE__) + "/fixtures/#{file_name}"
        require file_path
      rescue LoadError
        # Let's hope the developer has included it himself
      end
    end
  end
  
  # Turn off transactional fixtures if you're working with MyISAM tables in MySQL
  self.use_transactional_fixtures = true
#  self.use_transactional_fixtures = false
    
  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = false
#  self.use_instantiated_fixtures  = true

  # Add more helper methods to be used by all tests here...
end