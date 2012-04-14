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
    role = ::Role.find_by_name(role_name)
    with_role(role)
  end

  def with_role(role)
    where(:role_id => role && role.id)
  end

  def with_resource_class(resource_class)
    where(:resource_type => resource_type_from_class(resource_class))
  end
  
  # Create a record with the given attributes if there are no records
  # that already have those attributes.
  #
  # Returns the record if it was saved, otherwise nil.
  def create_if_unique!(attributes)
    user_role = new(attributes)
    
    record_attributes = user_role.attributes.reject do |k, v| 
      %w(id updated_at created_at).include?(k)
    end
    
    if !exists?(record_attributes) && user_role.save
      user_role
    else
      nil
    end
  end

  private

  def resource_type(resource)
    resource_type_from_class(resource.class)
  end

  def resource_type_from_class(resource_class)
    resource_class.name
  end
  
end