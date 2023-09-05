# Landlord

Landlord is a dynamic and hybrid multitenancy solution for Rails 6.0 and PostgreSQL. It allows you to manage multiple tenants within a single Rails application, simplifying the process of developing and maintaining applications with complex multitenant requirements.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem "landlord"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install landlord
```

After that, run the generator to create the necessary migrations and models:

```bash
$ rails generate landlord:install
```

Finally, run the migrations:

```bash
$ rails db:migrate
```

## Usage

### Database Configuration

Enable sharding.

```yaml
development:
  primary:
```

### Migrations

TODO: Add migrations of tenants

### Switching Tenants

Landlord provides you with easy methods to switch tenants in your application. The Landlord module contains methods like `switch_to_main` and `switch_to` that take a block of code to execute in the context of a specific tenant:

```ruby
Landlord.switch_to(tenant) do
  # Your code here
end
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
