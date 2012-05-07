module Roleable::Resource

  module ClassMethods
    def subject_model(model_name = nil)
      model_name && @subject_model = model_name
      @subject_model
    end
  end

  def self.included(base)
    base.has_many :subject_roles, :as => :resource
    base.extend(ClassMethods)
  end

  # Return a list of subjects that have the given role for this resource.
  #
  # ==== Examples
  #
  #   page.subjects_with_role(:editor)   # => [subject1, subject2, ...]
  #
  def subjects_with_role(role_name)
    subject = self.class.subject_model.constantize
    subject.joins(:subject_roles).merge(::SubjectRole.with_role_name(role_name).with_resource(self))
  end

end