require 'spec_helper'

describe Roleable::Subject do

  include_context 'with models'

  before do
    @subject = User.create
    @admin_role = Role.create(:name => 'admin')
    @editor_role = Role.create(:name => 'editor')
  end

  describe '#add_role' do

    context 'with a role that doesnt exist' do

      before do
        @result = @subject.add_role(:notarole)
      end

      it 'returns false' do
        @result.should be_false
      end

      it 'doesnt create a new subject_role' do
        SubjectRole.count.should == 0
      end

    end

    context 'without a resource' do

      before do
        @subject_role = @subject.add_role(:admin)
      end

      it 'creates a new subject role' do
        SubjectRole.count.should == 1
      end

      it 'associates the subject role with the given subject' do
        @subject_role.subject.should == @subject
      end

      it 'associates the subject role with the given role' do
        @subject_role.role.should == @admin_role
      end

      it 'sets the resource to nil' do
        @subject_role.resource.should == nil
      end

    end

    context 'with a resource' do

      before do
        @page = Page.create
        @subject_role = @subject.add_role(:admin, @page)
      end

      it 'associates the subject role with the given resource' do
        @subject_role.resource.should == @page
      end

      context 'when the subject already has the given role for the resource' do
        it 'doesnt create another subject role' do
          expect { @subject.add_role(:admin, @page) }.to_not change(SubjectRole, :count)
        end
      end

    end

  end

  describe '#has_role?' do

    context 'when the given role doesnt exist' do
      it 'is false' do
        @subject.has_role?(:notarole).should be_false
      end
    end

    context 'without a resource' do

      context 'when the subject DOESNT have the given role' do
        it 'is false' do
          @subject.has_role?(:admin).should be_false
        end
      end

      context 'when the subject DOES have the given role' do
        it 'is true' do
          @subject.add_role(:admin)
          @subject.has_role?(:admin).should be_true
        end
      end

    end

    context 'with a resource' do

      before do
        @page = Page.create
      end

      context 'when the subject DOESNT have the role for that resource' do
        it 'is false' do
          @subject.has_role?(:editor, @page).should be_false
        end
      end

      context 'when the subject DOES have the role for that resource' do
        it 'is true' do
          @subject.add_role(:editor, @page)
          @subject.has_role?(:editor, @page).should be_true
        end
      end

    end

  end

  describe '#remove_role' do

    context 'global' do

      context 'when the subject doesnt have the role' do
        it 'is false' do
          @subject.remove_role(:admin).should be_false
        end
      end

      context 'when the role doesnt exist' do
        it 'is false' do
          @subject.remove_role(:notarole).should be_false
        end
      end

      context 'when the subject has the given role' do

        before do
          @subject.add_role(:admin)
          @result = @subject.remove_role(:admin)
        end

        it 'is true' do
          @result.should be_true
        end

        it 'removes the given role' do
          @subject.has_role?(:admin).should be_false
        end

      end

    end

  end

  describe '#resources_with_role' do

    context 'when the subject has the given role for several resources of the given class' do
      it 'returns a list containing those resources' do
        3.times do
          page = Page.create
          @subject.add_role(:editor, page)
        end

        pages = @subject.resources_with_role(:editor, Page)

        pages.length.should == 3
        pages.first.should be_a(Page)
      end
    end

    context 'when the subject doesnt have the given role for any resources of the given class' do
      it 'returns an empty list' do
        @subject.resources_with_role(:editor, Page).should be_empty
      end
    end

  end

  describe '#roles_for_resource' do
    it 'returns a list of role objects for the roles this subject has for the given resource' do
      page = Page.create
      @subject.add_role(:editor, page)
      @subject.add_role(:admin, page)

      roles = @subject.roles_for_resource(page)
      roles.length.should == 2
      roles.first.should be_a(Role)
    end
  end

end