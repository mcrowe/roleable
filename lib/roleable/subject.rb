module Roleable::Subject

  module ClassMethods
    def acts_as_subject
      self.has_many :subject_roles, :foreign_key => 'subject_id'

      self.class_eval do

        # Add a role to the subject scoped to the given resource or global if no resource given.
        #
        # Does nothing if a role with the given name doesn't exist, or if the subject already has
        # the given role.
        #
        # ==== Examples
        #
        #   subject.add_role(:editor, page)    # Add the editor role to subject, scoped to page
        #   subject.add_role(:admin)           # Add the admin role to subject, globally
        #
        def add_role(role_name, resource = nil)
          role = ::Role.find_by_name(role_name) or return

          ::SubjectRole.create_if_unique!(:subject => self, :role => role, :resource => resource)
        end

        # Check if the subject has the given role for the given resource, or if they have the role globally
        # if no resource given.
        #
        # Returns <tt>true</tt> if the subject has the role, <tt>false</tt> otherwise.
        #
        # ==== Examples
        #
        #   subject.has_role?(:editor, page)   # True if the subject has the editor role for page
        #   subject.has_role?(:admin)          # True if the subject has a global admin role
        #
        def has_role?(role_name, resource = nil)
          subject_roles = ::SubjectRole.with_subject(self).with_resource(resource).with_role_name(role_name)

          subject_roles.exists?
        end

        # Remove the given role from the subject for the given resource, or globally if no resource given.
        #
        # Returns <tt>true</tt> if the role was found and deleted, <tt>false</tt> otherwise.
        #
        # ==== Examples
        #
        #   subject.remove_role(:editor, page)   # Remove the editor role from the subject for page
        #   subject.remove_role(:admin)          # Remove the global admin role from the subject
        #
        def remove_role(role_name, resource = nil)
          subject_roles = ::SubjectRole.with_subject(self).with_resource(resource).with_role_name(role_name)

          deleted_count = subject_roles.delete_all

          deleted_count > 0
        end

        # Return a list of resources of the given class, for which the subject has the given role.
        #
        # ==== Examples
        #
        #   subject.resources_with_role(:editor, Page)  # => [page1, page2, ...]
        #
        def resources_with_role(role_name, resource_class)
          subject_roles = ::SubjectRole.with_subject(self).with_role_name(role_name).with_resource_class(resource_class)
          resource_class.includes(:subject_roles).merge(subject_roles)
        end

        # Return a list of roles that the subject has for the given resource.
        #
        # ==== Examples
        #
        #   subject.roles_for_resource(page)   # => [role1, role2, ...]
        #
        def roles_for_resource(resource)
          subject_roles = ::SubjectRole.with_subject(self).with_resource(resource)
          ::Role.includes(:subject_roles).merge(subject_roles)
        end

      end

    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end

ActiveRecord::Base.send(:include, Roleable::Subject)
