# Landlord Gem

Landlord is a dynamic and hybrid multitenancy solution for Rails 6.0 and PostgreSQL. It allows you to manage multiple tenants within a single Rails application, simplifying the process of developing and maintaining applications with complex multitenant requirements.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'landlord', '~> 0.1.0'
```

And then execute:

```bash
bundle install
```

After that, run the generator to create the necessary migrations and models:

```bash
rails generate landlord:install
```

Finally, run the migrations:

```bash
rails db:migrate
```

## Usage

### Configuration
Firstly, in your ApplicationRecord model add the fetch_db_connections method call, and extend DbConnectionsFetcher:

```ruby
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend DbConnectionsFetcher

  fetch_db_connections
end
```

### Database Configuration

Enable sharding.

```yaml
development:
  primary:
```

### Migrations

TODO: Add migrations of tenants

### Switching Tenants

The Landlord gem provides you with easy methods to switch tenants in your application. The Landlord module contains methods like switch_to_main and switch_to that take a block of code to execute in the context of a specific tenant:

```ruby
Landlord.switch_to(tenant) do
  # Your code here
end
```

## Development

During development, if you need to switch tenants permanently for easier debugging in the terminal, use the switch! methods. These are only available in development or test environments:

```ruby
Landlord.switch!(connection_configuration)
Landlord.switch_to_main!
Landlord.switch_to!(tenant)
```