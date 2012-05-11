module Roleable::Resource

  def self.included(base)
    base.has_many :applied_roles, :as => :resource
  end

  # Return a list of users that have the given role for this resource.
  #
  # ==== Examples
  #
  #   page.subjects_with_role(:editor)   # => [user1, user2, ...]
  #
  def subjects_with_role(role_name)
    subject_class.joins(:applied_roles).
      merge( ::AppliedRole.with_role_name(role_name).with_resource(self) )
  end
  
  private
  
  def subject_class
    Roleable.configuration.subject_class_name.classify.constantize
  end
  
end