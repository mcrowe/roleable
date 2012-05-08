module Roleable::Role

  module ClassMethods
    def acts_as_role
      self.has_many :subject_roles
      self.attr_accessible :name
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end

ActiveRecord::Base.send(:include, Roleable::Role)
