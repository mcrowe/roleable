require 'rubygems'
require 'bundler/setup'

require 'sqlite3'
require 'active_record'
require 'with_model'
require 'roleable'

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path("../../#{f}", __FILE__) }

RSpec.configure do |config|
  config.extend WithModel
  
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
end