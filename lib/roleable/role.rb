module Roleable::Role #:nodoc:all

  def self.extended(base) 
    base.has_many :user_roles

    base.attr_accessible :name
  end
  
end