# Roleable

[![Build Status](https://secure.travis-ci.org/mcrowe/roleable.png?branch=master)](http://travis-ci.org/mcrowe/roleable)

A flexible roles solution for active-record-backed Rails 3 applications. Allows for multiple roles scoped to instances of any model, as well as global roles (admin, for example).

Roleable is designed to be ultra simple and obvious, letting you build upon it to satisfy your needs. It is also designed to be efficient: using database indices, and well-crafted queries so that it can handle a huge number of roles.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roleable'
```

And then execute:

    $ bundle

Run the generator to create the `Role` and `AppliedRole` models, migrations, and a configuration initializer:

    $ rails g roleable:install

And then run the migrations:

    $ rake db:migrate

(This will create the `roles` and `applied_roles` tables, together with the appropriate database indices.)

## Setup

Include `Roleable::Subject` into your subject model, e.g.:

```ruby
class User < ActiveRecord::Base
  include Roleable::Subject
  ...
end
```

Include `Roleable::Resource` into any models you want to relate a subject role to (resource), e.g.:

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
user.add_role(:editor, page)
```

Remove a role:

```ruby
# global
user.remove_role(:admin)

# resource-scoped
user.remove_role(:editor, page)
```

Query a role:

```ruby
# global
user.has_role?(:admin)

# resource-scoped
user.has_role?(:editor, page)
```

Find the resources of a given class for which a user has a given role:

```ruby
user.resources_with_role(:editor, Page)
```

Find the resource of a given class for which a user has _any_ of a list of roles:

```ruby
user.resources_with_role([:editor, :author], Page)
```

Find a user's roles for a given resource:

```ruby
user.roles_for_resource(page)
```

Or, all the global roles for a user:

```ruby
user.roles_for_resource(nil)
```

### Resource

Find subjects (users) with a given role:

```ruby
page.subjects_with_role(:editor)
```

Find subjects matching _any_ of a list of roles:

```ruby
page.subjects_with_role([:editor, :author])
```

## Customization

By default, roleable assumes that your subject model is called `User`. You can customize this by modifying the generated configuration intializer located at `config/initializers/roleable.rb`, e.g.:

```ruby
Roleable.configure do |config|
  config.subject_class_name = 'principle'
end
```

For more details check out the [API documentation](http://rubydoc.info/github/mcrowe/roleable/master/frames) on rubydoc.info.

## Requirements

Rails 3, ActiveRecord, Ruby >= 1.8.7

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
