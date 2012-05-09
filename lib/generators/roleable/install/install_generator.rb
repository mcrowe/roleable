require 'rails/generators/migration'

module Roleable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      desc 'Generates a role and a user_role model, along with migrations for their tables.'
      def generate_install
        copy_file 'role.rb', 'app/models/role.rb'
        copy_file 'subject_role.rb', 'app/models/subject_role.rb'
        migration_template 'migration.rb', 'db/migrate/roleable_create_roles_and_subject_roles.rb'
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

    end
  end
end