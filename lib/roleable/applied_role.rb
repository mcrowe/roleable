module Roleable::AppliedRole
  
  def self.extended(base)
    base.belongs_to :subject, :class_name => Roleable.configuration.subject_class_name
    base.belongs_to :role
    base.belongs_to :resource, :polymorphic => true
    
    base.attr_accessible :role, :subject_id, :resource
  end

  def with_subject(subject)
    where(:subject_id => subject && subject.id)
  end

  def with_resource(resource)
    where(:resource_id => resource && resource.id, :resource_type => resource && resource_type(resource))
  end

  def with_role_name(role_name)
    roles = ::Role.find_all_by_name(role_name)
    with_roles(roles)
  end

  def with_roles(roles)
    role_ids = roles.map { |r| r.id }
    where(:role_id => role_ids)
  end

  def with_resource_class(resource_class)
    where(:resource_type => resource_type_from_class(resource_class))
  end
  
  # Create a record with the given attributes if there are no records
  # that already have those attributes.
  #
  # Returns the record if it was saved, otherwise nil.
  def create_if_unique!(attributes)  
    applied_role = new(attributes)

    record_attributes = applied_role.attributes.reject do |k, v| 
      %w(id updated_at created_at).include?(k)
    end
    
    if !exists?(record_attributes) && applied_role.save
      applied_role
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