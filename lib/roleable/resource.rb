module Roleable::Resource

  def self.included(base)
    base.has_many :user_roles, :as => :resource
  end

  # Return a list of users that have the given role for this resource.
  #
  # ==== Examples
  #
  #   page.users_with_role(:editor)   # => [user1, user2, ...]
  #
  def users_with_role(role_name)
    user_roles = ::UserRole.with_role_name(role_name)
    User.joins(:user_roles).merge(user_roles)
  end
  
end