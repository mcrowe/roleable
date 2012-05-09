module Roleable::Resource

  def self.included(base)
    base.has_many :user_roles, :as => :resource
  end

  # Return a list of users that have the given role for this resource.
  # If a list of role names is given, return users with any of those roles for this resource.
  #
  # ==== Examples
  #
  #   page.users_with_role(:editor)   # => [user1, user2, ...]
  #   page.users_with_role([:editor, :author])   # => [user1, user2, ...]
  #
  def users_with_role(role_name)
    User.joins(:user_roles).merge(::UserRole.with_role_name(role_name).with_resource(self))
  end
  
end