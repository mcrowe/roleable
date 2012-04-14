module Roleable::Subject
  
  def self.included(base) #:nodoc: all
    base.has_many :user_roles
  end

  # Add a role to the user scoped to the given resource or global if no resource given.
  #
  # Does nothing if a role with the given name doesn't exist, or if the user already has
  # the given role.
  #
  # ==== Examples
  #
  #   user.add_role(:editor, page)    # Add the editor role to user, scoped to page
  #   user.add_role(:admin)           # Add the admin role to user, globally
  #
  def add_role(role_name, resource = nil)
    role = ::Role.find_by_name(role_name) or return
    
    ::UserRole.create_if_unique!(:user => self, :role => role, :resource => resource)    
  end

  # Check if the user has the given role for the given resource, or if they have the role globally
  # if no resource given.
  #
  # Returns <tt>true</tt> if the user has the role, <tt>false</tt> otherwise.
  #
  # ==== Examples
  #
  #   user.has_role?(:editor, page)   # True if the user has the editor role for page
  #   user.has_role?(:admin)          # True if the user has a global admin role
  #
  def has_role?(role_name, resource = nil)
    user_roles = ::UserRole.with_user(self).with_resource(resource).with_role_name(role_name)
    
    user_roles.exists?    
  end
  
  # Remove the given role from the user for the given resource, or globally if no resource given.
  #
  # Returns <tt>true</tt> if the role was found and deleted, <tt>false</tt> otherwise.
  #
  # ==== Examples
  #
  #   user.remove_role(:editor, page)   # Remove the editor role from the user for page
  #   user.remove_role(:admin)          # Remove the global admin role from the user
  #
  def remove_role(role_name, resource = nil)
    user_roles = ::UserRole.with_user(self).with_resource(resource).with_role_name(role_name)
    
    deleted_count = user_roles.delete_all
        
    deleted_count > 0
  end
  
  # Return a list of resources of the given class, for which the user has the given role.
  #
  # ==== Examples
  #
  #   user.resources_with_role(:editor, Page)  # => [page1, page2, ...]
  #
  def resources_with_role(role_name, resource_class)
    user_roles = ::UserRole.with_user(self).with_role_name(role_name).with_resource_class(resource_class)
    resource_class.includes(:user_roles).merge(user_roles)
  end
  
  # Return a list of roles that the user has for the given resource.
  #
  # ==== Examples
  #
  #   user.roles_for_resource(page)   # => [role1, role2, ...]
  #  
  def roles_for_resource(resource)
    user_roles = ::UserRole.with_user(self).with_resource(resource)    
    ::Role.includes(:user_roles).merge(user_roles)
  end
  
end