require 'spec_helper'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

describe Roleable::RoleSubject do
  
  with_model :User do
    table do |t|
      t.string :name
    end

    model do
      include Roleable::RoleSubject
    end
  end
  
  with_model :Page do
    table do |t|
      t.string :title
    end
    
    model do
      include Roleable::RoleObject
    end
  end
  
  with_model :Role do
    table do |t|
      t.string :name
    end
  end
  
  with_model :UserRole do
    table do |t|
      t.integer :user_id
      t.integer :role_id
      t.integer :object_id
      t.string :object_type
    end
    
    model do
      belongs_to :user
      belongs_to :role
      belongs_to :object, :polymorphic => true
    end
  end
  
  describe '#test' do
    it 'is true' do
      Roleable::RoleSubject.test.should be_true
    end
  end
  
end