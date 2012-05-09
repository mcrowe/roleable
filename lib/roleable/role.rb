module Roleable::Role

  def acts_as_role
    self.has_many :subject_roles
    self.attr_accessible :name
  end

end

ActiveRecord::Base.send(:extend, Roleable::Role)
