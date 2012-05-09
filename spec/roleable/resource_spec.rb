require 'spec_helper'

describe Roleable::Resource do

  include_context 'with models'

  describe '#subjects_with_role' do

    before do
      @page = Page.create
      @editor_role = Role.create(:name => 'editor')
    end

    context 'with a role that doesnt exist' do
      it 'returns an empty list' do
        @page.subjects_with_role(:notarole).should be_empty
      end
    end

    context 'when multiple subjects have the given role' do

      before do
        3.times { User.create!.add_role(:editor, @page) }
      end

      it 'returns a list of the subjects' do
        subjects = @page.subjects_with_role(:editor)

        subjects.length.should == 3
        subjects.first.should be_a(User)
      end

      it 'doesnt return subjects that dont have the role' do
        other_page = Page.create
        other_subject = User.create!.add_role(:editor, other_page)

        subjects = @page.subjects_with_role(:editor)

        subjects.length.should == 3
      end

    end

  end

end