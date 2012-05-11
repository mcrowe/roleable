require 'spec_helper'

describe Roleable::Resource do

  include_context 'with models'
  
  describe '#subjects_with_role' do
    
    before do
      @page = Page.create
      @editor_role = Role.create(:name => 'editor')
      @author_role = Role.create(:name => 'author')
    end

    context 'with a single role' do
      
      context 'with a role that doesnt exist' do
        it 'returns an empty list' do
          @page.subjects_with_role(:notarole).should be_empty
        end
      end
    
      context 'when multiple users have the given role' do
      
        before do
          3.times { User.create.add_role(:editor, @page) }
        end        
        

        it 'returns a list of the users' do    
          users = @page.subjects_with_role(:editor)
        
          users.length.should == 3
          users.first.should be_a(User)
        end
      
        it 'doesnt return users that dont have the role' do
          other_page = Page.create
          other_user = User.create.add_role(:editor, other_page)

          users = @page.subjects_with_role(:editor)
        
          users.length.should == 3
        end
      
      end
      
    end
    
    context 'with a list of roles' do
      it 'returns a list of users that have any of the given roles for this resource' do
        3.times { User.create.add_role(:editor, @page) }
        2.times { User.create.add_role(:author, @page) }
        User.create
        
        users = @page.subjects_with_role([:editor, :author])
      
        users.length.should == 5
      end
    end
    
  end
  
end