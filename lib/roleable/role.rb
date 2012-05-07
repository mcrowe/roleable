module Roleable::Role

  def self.extended(base)
    base.has_many :subject_roles

    base.attr_accessible :name
  end

end
