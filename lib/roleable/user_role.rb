module Roleable::UserRole
  
  def self.extended(base)  
    base.belongs_to :user
    base.belongs_to :role
    base.belongs_to :resource, :polymorphic => true
    
    base.attr_accessible :role, :user, :resource
  end

  def with_user(user)
    where(:user_id => user && user.id)
  end

  def with_resource(resource)
    where(:resource_id => resource && resource.id, :resource_type => resource && resource_type(resource))
  end

  def with_role_name(role_name)
    role = Role.find_by_name(role_name)
    with_role(role)
  end

  def with_role(role)
    where(:role_id => role && role.id)
  end

  def with_resource_class(resource_class)
    where(:resource_type => resource_type_from_class(resource_class))
  end

  private

  def resource_type(resource)
    resource_type_from_class(resource.class)
  end

  def resource_type_from_class(resource_class)
    resource_class.name
  end
  
end