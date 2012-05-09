module Roleable::Resource

  def acts_as_resource(opts={:class_name => nil})
    self.has_many :subject_roles, :as => :resource

    @@model_name = opts[:class_name] || 'Subject'

    self.class_eval do
      # Return a list of subjects that have the given role for this resource.
      #
      # ==== Examples
      #
      #   page.subjects_with_role(:editor)   # => [subject1, subject2, ...]
      #
      def subjects_with_role(role_name)
        subject = @@model_name.constantize
        subject.joins(:subject_roles).merge(::SubjectRole.with_role_name(role_name).with_resource(self))
      end
    end
  end

end

ActiveRecord::Base.send(:extend, Roleable::Resource)
