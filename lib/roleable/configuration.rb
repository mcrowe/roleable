class Roleable::Configuration
  
  attr_accessor :subject_class_name

  def initialize
    @subject_class_name = 'User'
  end
    
end