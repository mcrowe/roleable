# Roleable

Add user roles to your active_record-backed rails app. A user can have multiple roles associated to many instances of any model, as well as global roles (admin, for example). Roleable is designed to be ultra simple and obvious, letting you build upon it to satisfy your needs.

## Installation

Add this line to your application's Gemfile:

  ```ruby
  gem 'roleable'
  ```

And then execute:

    $ bundle

Create `user_roles` and `roles` table migrations using the generator:

    $ rails g roleable:install
    
Run the migrations:

    $ rake db:migrate
    
Include `Roleable::Subject` into your user (subject) model:

  ```ruby
  class User << ActiveRecord::Base
    include Roleable::Subject
    ...
  end
  ```  

Include `Roleable::Object` into any models you want to relate a user role to:

  ```ruby
  class Page << ActiveRecord::Base
    include Roleable::Object
    ...
  end
  ```

## Usage

### Subject API

Adding a user role:

  ```ruby
  # A global role.
  user.add_role(:admin)
  
  # An object-related role.
  page = Page.last
  user.add_role(:author, page)
  ```

Remove a role:

  ```ruby
  # A global role.
  user.remove_role(:admin)
  
  # An object-related role.
  page = Page.last
  user.remove_role(:author, page)
  ```
  
Check for a role:

  ```ruby
  # A global role.
  user.has_role?(:admin)
  
  # An object-related role.
  page = Page.last
  user.has_role?(:author, page)
  
Get all the objects matching a role:

  ```ruby
  user.objects_for_role(:author, Page)
  ```  

Get all the users roles for a given object:

  ```ruby
  page = Page.last
  user.roles_for_object(page)
  
  # Or, all the global roles for a user:
  user.roles_for_object(nil)
  ```
  
### Object API

Get all the users with a given role for this object:

  ```ruby
  page.users_with_role(:author)
  ```
 
## Requirements

Rails 3, ActiveRecord, Ruby >= 1.8.7

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
