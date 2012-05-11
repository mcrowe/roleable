shared_context 'with models' do

  with_model :User do
    model { include Roleable::Subject }
  end

  with_model :Page do
    model { include Roleable::Resource }
  end

  with_model :Role do
    table { |t| t.string :name }
    model { extend Roleable::Role }
  end

  with_model :AppliedRole do
    table do |t|
      t.integer :subject_id
      t.integer :role_id
      t.integer :resource_id
      t.string :resource_type
      
      t.timestamps
    end
    model { extend Roleable::AppliedRole }
  end
  
end