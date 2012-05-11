require 'spec_helper'

describe Roleable::Subject do

  include_context 'with models'
    
  before do
    @user = User.create
    @admin_role = Role.create(:name => 'admin')
    @editor_role = Role.create(:name => 'editor')
    @author_role = Role.create(:name => 'author')
  end

  describe '#add_role' do
  
    context 'with a role that doesnt exist' do
    
      before do
        @result = @user.add_role(:notarole)
      end
    
      it 'returns false' do
        @result.should be_false
      end
    
      it 'doesnt create a new applied_role' do
        AppliedRole.count.should == 0
      end
    
    end
  
    context 'without a resource' do
  
      before do
        @user_role = @user.add_role(:admin)
      end
  
      it 'creates a new user role' do
        AppliedRole.count.should == 1
      end
    
      it 'associates the user role with the given user' do
        @user_role.subject.should == @user
      end          

      it 'associates the user role with the given role' do
        @user_role.role.should == @admin_role
      end
    
      it 'sets the resource to nil' do
        @user_role.resource.should == nil
      end
      
    end
  
    context 'with a resource' do
    
      before do
        @page = Page.create
        @user_role = @user.add_role(:admin, @page)
      end
    
      it 'associates the user role with the given resource' do
        @user_role.resource.should == @page
      end
      
      context 'when the user already has the given role for the resource' do
        it 'doesnt create another user role' do
          expect { @user.add_role(:admin, @page) }.to_not change(AppliedRole, :count)
        end
      end
          
    end
  
  end

  describe '#has_role?' do

    context 'when the given role doesnt exist' do
      it 'is false' do
        @user.has_role?(:notarole).should be_false
      end
    end

    context 'without a resource' do
    
      context 'when the user DOESNT have the given role' do    
        it 'is false' do
          @user.has_role?(:admin).should be_false
        end
      end
    
      context 'when the user DOES have the given role' do
        it 'is true' do
          @user.add_role(:admin)
          @user.has_role?(:admin).should be_true
        end
      end
    
    end
  
    context 'with a resource' do
 
      before do
        @page = Page.create
      end
    
      context 'when the user DOESNT have the role for that resource' do
        it 'is false' do
          @user.has_role?(:editor, @page).should be_false
        end
      end
    
      context 'when the user DOES have the role for that resource' do
        it 'is true' do
          @user.add_role(:editor, @page)
          @user.has_role?(:editor, @page).should be_true
        end
      end
    
    end
  
  end

  describe '#remove_role' do
  
    context 'global' do

      context 'when the user doesnt have the role' do
        it 'is false' do
          @user.remove_role(:admin).should be_false
        end
      end
      
      context 'when the role doesnt exist' do
        it 'is false' do
          @user.remove_role(:notarole).should be_false
        end
      end
    
      context 'when the user has the given role' do
      
        before do
          @user.add_role(:admin)
          @result = @user.remove_role(:admin)
        end
      
        it 'is true' do
          @result.should be_true
        end
      
        it 'removes the given role' do
          @user.has_role?(:admin).should be_false
        end
      
      end
    
    end
  
  end

  describe '#resources_with_role' do
  
    context 'with a single role' do
    
      context 'when the user has the given role for several resources of the given class' do
        it 'returns a list containing those resources' do
          3.times { @user.add_role(:editor, Page.create) }
      
          pages = @user.resources_with_role(:editor, Page)
        
          pages.length.should == 3
          pages.first.should be_a(Page)
        end
      end
  
      context 'when the user doesnt have the given role for any resources of the given class' do
        it 'returns an empty list' do
          @user.resources_with_role(:editor, Page).should be_empty        
        end
      end
      
    end
    
    context 'with a list of roles' do
      it 'returns a list of resources the user has those roles for' do
        3.times { @user.add_role(:editor, Page.create) }
        2.times { @user.add_role(:author, Page.create) }
        Page.create
        
        pages = @user.resources_with_role([:editor, :author], Page)
        
        pages.length.should == 5        
      end
    end
  
  end

  describe '#roles_for_resource' do
    it 'returns a list of role objects for the roles this user has for the given resource' do
      page = Page.create
      @user.add_role(:editor, page)
      @user.add_role(:admin, page)
    
      roles = @user.roles_for_resource(page)
      roles.length.should == 2
      roles.first.should be_a(Role)
    end
  end
  
end