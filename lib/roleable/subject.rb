module Roleable::Subject
  
  def self.included(base)
    base.has_many :applied_roles, :foreign_key => 'subject_id'
  end

  # Add a role to the subject scoped to the given resource or global if no resource given.
  #
  # Does nothing if a role with the given name doesn't exist, or if the subject already has
  # the given role.
  #
  # ==== Examples
  #
  #   user.add_role(:editor, page)    # Add the editor role to user, scoped to page
  #   user.add_role(:admin)           # Add the admin role to user, globally
  #
  def add_role(role_name, resource = nil)
    role = ::Role.find_by_name(role_name) or return
    
    ::AppliedRole.create_if_unique!(:subject_id => self.id, :role => role, :resource => resource)    
  end

  # Check if the subject has the given role for the given resource, or if they have the role globally
  # if no resource given.
  #
  # Returns <tt>true</tt> if the subject has the role, <tt>false</tt> otherwise.
  #
  # ==== Examples
  #
  #   user.has_role?(:editor, page)   # True if the user has the editor role for page
  #   user.has_role?(:admin)          # True if the user has a global admin role
  #
  def has_role?(role_name, resource = nil)
    ::AppliedRole.
      with_subject(self).
      with_resource(resource).
      with_role_name(role_name).
      exists?
  end
  
  # Remove the given role from the subject for the given resource, or globally if no resource given.
  #
  # Returns <tt>true</tt> if the role was found and deleted, <tt>false</tt> otherwise.
  #
  # ==== Examples
  #
  #   user.remove_role(:editor, page)   # Remove the editor role from the user for page
  #   user.remove_role(:admin)          # Remove the global admin role from the user
  #
  def remove_role(role_name, resource = nil)
    applied_roles = ::AppliedRole.with_subject(self).with_resource(resource).with_role_name(role_name)
    
    deleted_count = applied_roles.delete_all
        
    deleted_count > 0
  end
  
  # Return a list of resources of the given class, for which the subject has the given role.
  #
  # ==== Examples
  #
  #   user.resources_with_role(:editor, Page)  # => [page1, page2, ...]
  #
  def resources_with_role(role_name, resource_class)
    applied_roles = ::AppliedRole.with_subject(self).with_role_name(role_name).with_resource_class(resource_class)
    resource_class.includes(:applied_roles).merge(applied_roles)
  end
  
  # Return a list of roles that the subject has for the given resource.
  #
  # ==== Examples
  #
  #   user.roles_for_resource(page)   # => [role1, role2, ...]
  #  
  def roles_for_resource(resource)
    applied_roles = ::AppliedRole.with_subject(self).with_resource(resource)    
    ::Role.includes(:applied_roles).merge(applied_roles)
  end
  
end