class Role < ActiveRecord::Base
  
  extend Roleable::Role
  
  # Re-populate all of the roles from those defined in config/system_subscription_plans.yml.
  def self.populate
    destroy_all
    create!(YAML.load_file("#{Rails.root}/config/roles.yml"))
  end
  
end