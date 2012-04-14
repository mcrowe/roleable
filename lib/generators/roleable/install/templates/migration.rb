class RoleableCreateRolesAndUserRoles < ActiveRecord::Migration
  
  def change
    create_table :roles do |t|
      t.string :name      
      t.timestamps
    end

    create_table :user_roles do |t|
      t.references :user
      t.references :role
      t.references :resource, :polymorphic => true
      t.timestamps
    end
    
    add_index :user_roles, :user_id
    add_index :user_roles, :role_id
    add_index :user_roles, [:resource_type, :resource_id]
  end
  
end