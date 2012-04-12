require 'spec_helper'

describe Roleable::Resource do

  include_context 'with models'
  
  describe '#users_with_role' do
    
    before do
      @page = Page.create
      @editor_role = Role.create(:name => 'editor')
    end
    
    context 'with a role that doesnt exist' do
      it 'returns an empty list' do
        @page.users_with_role(:notarole).should be_empty
      end
    end
    
    context 'when multiple users have the given role' do
      it 'returns a list of the users' do
        3.times do
          user = User.create
          user.add_role(:editor, @page)
        end
        
        users = @page.users_with_role(:editor)
        
        users.length.should == 3
        users.first.should be_a(User)
      end
    end
    
  end
  
end