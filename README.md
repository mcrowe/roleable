# Roleable

A flexible user-roles gem for active-record-backed Rails 3 applications. Allows for multiple roles scoped to instances of any model, as well as global roles (admin, for example). 

Roleable is designed to be ultra simple and obvious, letting you build upon it to satisfy your needs. It is also designed to be efficient, using database indices, and well-crafted queries so that it can handle huge numbers of roles.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roleable'
```

And then execute:

    $ bundle

Run the generator to create migrations and stub models for `Role` and `UserRole`:

    $ rails g roleable:install
    
And then run the migrations:

    $ rake db:migrate
    
(This will create the user_roles and roles tables, together with the appropriate database indices.)

## Setup
    
Include `Roleable::Subject` into your user (subject) model, e.g.:

```ruby
class User < ActiveRecord::Base
  include Roleable::Subject
  ...
end
```  

Include `Roleable::Resource` into any models you want to relate a user role to (resource), e.g.:

```ruby
class Page < ActiveRecord::Base
  include Roleable::Resource
  ...
end
```

## Usage

### Subject

Add a role:

```ruby
# global
user.add_role(:admin)

# resource-scoped
user.add_role(:editor, Page.first)
```

Remove a role:

```ruby
# global
user.remove_role(:admin)
  
# resource-scoped
user.remove_role(:editor, Page.first)
```
  
Query a role:

```ruby
# global
user.has_role?(:admin)

# resource-scoped
user.has_role?(:editor, Page.first)
```
  
Get resources of a given class for which a user has a given role:

```ruby
user.resources_with_role(:editor, Page)
```  

Get a user's roles for a given resource:

```ruby
user.roles_for_resource(Page.first)

# Or, all the global roles for a user:
user.roles_for_resource(nil)
```
  
### Resource

Get users with a given role:

```ruby
Page.first.users_with_role(:editor)
```
 
## Requirements

Rails 3, ActiveRecord, Ruby >= 1.8.7

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request