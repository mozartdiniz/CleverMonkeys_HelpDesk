require 'acts_as_urlnameable'
require File.dirname(__FILE__) + '/lib/urlname'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Urlnameable)