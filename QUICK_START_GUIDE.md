# Quick Start Integration Guide

This guide will help you integrate the website user registration with encryption key password into your existing Rails application in just a few steps.

## Prerequisites

- Existing Rails application with Devise already configured
- User model exists
- Database accessible

## Step-by-Step Integration

### Step 1: Copy Files to Your Rails App

Copy these files from this repository to your Rails application:

```bash
# Controller
cp app/controllers/users/registrations_controller.rb YOUR_RAILS_APP/app/controllers/users/

# Model
cp app/models/encryption_key.rb YOUR_RAILS_APP/app/models/

# View
cp app/views/users/registrations/new.html.erb YOUR_RAILS_APP/app/views/users/registrations/

# Migration
cp db/migrate/20251125091900_create_encryption_keys.rb YOUR_RAILS_APP/db/migrate/
```

### Step 2: Update Your User Model

Open `app/models/user.rb` and add the encryption key association:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Add this line:
  has_one :encryption_key, dependent: :destroy
  
  # ... rest of your existing code
end
```

### Step 3: Update Routes

Open `config/routes.rb` and update your Devise routes:

```ruby
Rails.application.routes.draw do
  # Replace this:
  # devise_for :users
  
  # With this:
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # ... rest of your routes
end
```

### Step 4: Install BCrypt (if needed)

Check your `Gemfile` for BCrypt. If it's not present, add:

```ruby
gem 'bcrypt', '~> 3.1.7'
```

Then run:
```bash
bundle install
```

### Step 5: Run the Migration

```bash
rails db:migrate
```

### Step 6: Test It!

1. Start your Rails server:
```bash
rails server
```

2. Navigate to the registration page:
```
http://localhost:3000/users/sign_up
```

3. Fill in the form including the new "Encryption Key Password" field

4. Submit and verify the user is created

5. Check the database:
```bash
rails console
> user = User.last
> user.encryption_key
# Should return the EncryptionKey object
```

## Verification Checklist

- [ ] Files copied to correct locations
- [ ] User model updated with `has_one :encryption_key`
- [ ] Routes updated to use custom controller
- [ ] BCrypt gem installed (if needed)
- [ ] Migration run successfully
- [ ] Server starts without errors
- [ ] Registration form shows encryption key password field
- [ ] Can successfully register a new user
- [ ] EncryptionKey record created in database
- [ ] Encryption key associated with new user

## Testing the Integration

### Manual Test

```ruby
# In Rails console:
rails console

# Create a user through the registration form, then check:
user = User.last
puts "User email: #{user.email}"
puts "Has encryption key: #{user.encryption_key.present?}"
puts "Encrypted key: #{user.encryption_key.encrypted_key}"
puts "Salt: #{user.encryption_key.salt}"
```

### Running the Test Suite

If you copied the spec files:

```bash
# Run all tests
rspec

# Run specific tests
rspec spec/controllers/users/registrations_controller_spec.rb
rspec spec/models/encryption_key_spec.rb
rspec spec/features/user_registration_with_encryption_spec.rb
```

## Customization Options

### Change the Field Label

In `app/views/users/registrations/new.html.erb`, change:
```erb
<%= f.label :encryption_key_password, "Encryption Key Password" %>
```

To whatever label you prefer:
```erb
<%= f.label :encryption_key_password, "Data Encryption Password" %>
```

### Change the Help Text

Update the help text to match your application's needs:
```erb
<small class="form-text text-muted">
  Your custom help text here.
</small>
```

### Make the Field Optional

If you want the encryption key to be optional:

1. Remove `required: true` from the form field in the view
2. The controller already handles cases where encryption_key_password is not provided

### Add Password Confirmation

Add a confirmation field in the view:
```erb
<div class="field">
  <%= f.label :encryption_key_password_confirmation %><br />
  <%= f.password_field :encryption_key_password_confirmation, autocomplete: "new-password" %>
</div>
```

## Troubleshooting

### "Uninitialized constant EncryptionKey"

**Solution**: Make sure you ran the migration and the EncryptionKey model file exists.

### "NoMethodError: undefined method 'encryption_key'"

**Solution**: Add `has_one :encryption_key, dependent: :destroy` to your User model.

### "Routing Error"

**Solution**: Make sure you updated `config/routes.rb` with the custom controller configuration.

### "User already has an encryption key" error

**Solution**: This is expected behavior. Each user can only have one encryption key. If testing, delete the existing key first or use a new user.

### Form doesn't show encryption key field

**Solution**: Make sure you copied the view file to the correct location: `app/views/users/registrations/new.html.erb` (note the nested `users/registrations` directory structure).

## Rolling Back

If you need to rollback this feature:

```bash
# Rollback the migration
rails db:rollback

# Remove or revert the changes to:
# - app/controllers/users/registrations_controller.rb
# - app/models/encryption_key.rb
# - app/views/users/registrations/new.html.erb
# - User model association
# - Routes configuration
```

## Production Deployment

Before deploying to production:

1. **Test thoroughly** in staging environment
2. **Backup your database**
3. **Run migration**: `rails db:migrate RAILS_ENV=production`
4. **Ensure HTTPS** is enabled (required for password security)
5. **Monitor** the first few registrations to ensure everything works
6. **Update documentation** for your users about the encryption key

## Need Help?

Refer to the detailed documentation:
- `ENCRYPTION_KEY_IMPLEMENTATION.md` - Comprehensive technical documentation
- `IMPLEMENTATION_SUMMARY.md` - High-level overview and design decisions

## API Consistency

This implementation is designed to work consistently with your existing mobile API. Both web and mobile users will have their encryption keys stored in the same way:
- Same database table
- Same encryption method (BCrypt)
- Same security approach
- Consistent user experience

You're all set! 🎉
