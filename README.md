# Roleable

Add user roles to your active_record-backed rails app. A user can have multiple roles associated to many instances of any model, as well as global roles (admin, for example). Roleable is designed to be ultra simple and obvious, letting you build upon it to satisfy your needs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roleable'
```

And then execute:

    $ bundle

Run the generator to create the necessary migrations:

    $ rails g roleable:install
    
And then run the migrations:

    $ rake db:migrate
    
(This will create the user_roles and roles tables, together with the appropriate database indices.)
    
Include `Roleable::Subject` into your user (subject) model:

```ruby
class User << ActiveRecord::Base
  include Roleable::Subject
  ...
end
```  

Include `Roleable::Object` into any models you want to relate a user role to (objects):

```ruby
class Page << ActiveRecord::Base
  include Roleable::Object
  ...
end
```

## Usage

### Subject API

Add a role:

```ruby
# A global role.
user.add_role(:admin)

# An object-related role.
user.add_role(:author, Page.last)
```

Remove a role:

```ruby
# A global role.
user.remove_role(:admin)
  
# An object-related role.
user.remove_role(:author, Page.last)
```
  
Query a role:

```ruby
# A global role.
user.has_role?(:admin)

# An object-related role.
user.has_role?(:author, Page.last)
```
  
Get objects of a given class for which a user has a given role:

```ruby
user.objects_with_role(:author, Page)
```  

Get a user's roles for a given object:

```ruby
page = Page.last
user.roles_for_object(Page.last)

# Or, all the global roles for a user:
user.roles_for_object(nil)
```
  
### Object API

Get users with a given role for an object:

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