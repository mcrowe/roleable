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

  with_model :UserRole do
    table do |t|
      t.integer :user_id
      t.integer :role_id
      t.integer :resource_id
      t.string :resource_type
    end
    model { extend Roleable::UserRole }
  end
  
end