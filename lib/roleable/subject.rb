module Roleable::Subject
  
  def self.included(base)
    base.has_many :user_roles
  end

  def add_role(role_name, resource = nil)
    role = ::Role.find_by_name(role_name) or return
    
    ::UserRole.create_if_unique!(:user => self, :role => role, :resource => resource)    
  end

  def has_role?(role_name, resource = nil)
    user_roles = ::UserRole.with_user(self).with_resource(resource).with_role_name(role_name)
    
    user_roles.exists?    
  end
  
  def remove_role(role_name, resource = nil)
    user_roles = ::UserRole.with_user(self).with_resource(resource).with_role_name(role_name)
    
    deleted_count = user_roles.delete_all
        
    deleted_count > 0
  end
  
  def resources_with_role(role_name, resource_class)
    user_roles = ::UserRole.with_user(self).with_role_name(role_name).with_resource_class(resource_class)
    resource_class.includes(:user_roles).merge(user_roles)
  end
  
  def roles_for_resource(resource)
    user_roles = ::UserRole.with_user(self).with_resource(resource)    
    ::Role.includes(:user_roles).merge(user_roles)
  end
  
end