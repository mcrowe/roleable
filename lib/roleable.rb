require 'roleable/version'
require 'roleable/subject'
require 'roleable/resource'
require 'roleable/role'
require 'roleable/applied_role'
require 'roleable/configuration'

module Roleable
  
  def self.configuration
    @configuration ||= Roleable::Configuration.new
  end
  
  def self.configure
    yield configuration if block_given?
  end
  
end