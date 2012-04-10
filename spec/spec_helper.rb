require 'rubygems'
require 'bundler/setup'

require 'sqlite3'
require 'active_record'
require 'with_model'
require 'roleable'

RSpec.configure do |config|
  config.extend WithModel
end