shared_context 'with models' do

  with_model :User do
    model { acts_as_subject }
  end

  with_model :Page do
    model { acts_as_resource :class_name => 'User' }
  end

  with_model :Role do
    table { |t| t.string :name }
    model { acts_as_role }
  end

  with_model :SubjectRole do
    table do |t|
      t.integer :subject_id
      t.integer :role_id
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end
    model { acts_as_subject_role :class_name => 'User' }
  end

end