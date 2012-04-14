module Roleable::Role

  def self.extended(base) 
    base.has_many :user_roles

    base.attr_accessible :name
  end
  
end