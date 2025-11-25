# User Registration with Encryption Key Implementation

This implementation adds encryption key password support to the website user registration flow, matching the functionality already available in the mobile API.

## Overview

When users register on the website, they will be prompted to enter:
1. Email address
2. Password (for account authentication)
3. Encryption Key Password (for data encryption)

The encryption key password is stored separately and used to encrypt user data, just like in the mobile application.

## Files Created

### 1. Controller
**File:** `app/controllers/users/registrations_controller.rb`

This custom Devise registrations controller:
- Extends the default Devise registration process
- Accepts `encryption_key_password` parameter
- Creates an `EncryptionKey` record when user registers
- Encrypts the password using BCrypt before storing

Key methods:
- `create`: Handles user registration and encryption key creation
- `configure_sign_up_params`: Permits the encryption_key_password parameter
- `create_encryption_key`: Creates the encryption key record
- `encrypt_key`: Encrypts the password using BCrypt
- `generate_salt`: Generates a random salt for additional security

### 2. View
**File:** `app/views/users/registrations/new.html.erb`

Registration form that includes:
- Email field
- Password field
- Password confirmation field
- **Encryption Key Password field** (new)
- Help text explaining the purpose of the encryption key

The encryption key password field is required and includes helpful text to guide users.

### 3. Model
**File:** `app/models/encryption_key.rb`

The EncryptionKey model:
- Belongs to User (one-to-one relationship)
- Validates presence of encrypted_key and salt
- Ensures one encryption key per user
- Stores the encrypted password and salt

### 4. Migration
**File:** `db/migrate/20251125091900_create_encryption_keys.rb`

Creates the `encryption_keys` table with:
- `user_id`: Foreign key to users table (unique index)
- `encrypted_key`: Stores the encrypted password
- `salt`: Stores the random salt for encryption
- Timestamps for created_at and updated_at

## Setup Instructions

### 1. Update Routes
Add the custom controller to your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # ... rest of your routes
end
```

### 2. Update User Model
Add the association to your `app/models/user.rb`:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :encryption_key, dependent: :destroy
  
  # ... rest of your User model code
end
```

### 3. Run Migration
```bash
rails db:migrate
```

### 4. Add BCrypt Gem (if not already present)
Ensure your `Gemfile` includes:

```ruby
gem 'bcrypt', '~> 3.1.7'
```

Then run:
```bash
bundle install
```

## How It Works

1. **User visits registration page** (`/users/sign_up`)
   - Form displays with email, password, password confirmation, and encryption key password fields

2. **User submits registration form**
   - Controller receives all parameters including `encryption_key_password`
   - User record is created with standard Devise authentication

3. **Encryption key is created**
   - After successful user creation, `create_encryption_key` method is called
   - Password is encrypted using BCrypt
   - Random salt is generated
   - EncryptionKey record is stored in database

4. **User is signed in**
   - Standard Devise flow continues
   - User receives confirmation of successful registration

## Security Considerations

1. **Separate Passwords**: The encryption key password is separate from the account password, providing an additional layer of security
2. **BCrypt Encryption**: Uses BCrypt for secure password hashing
3. **Random Salt**: Each encryption key has a unique salt for additional security
4. **One Key Per User**: Enforces one encryption key per user at the model level
5. **HTTPS Required**: Ensure your application uses HTTPS to protect passwords in transit

## Testing

To test the implementation:

1. Start your Rails server
2. Navigate to `/users/sign_up`
3. Fill in all fields including the encryption key password
4. Submit the form
5. Verify user is created successfully
6. Check database: `EncryptionKey.last` should show the created encryption key
7. Verify the encryption key belongs to the new user

## API Consistency

This implementation matches the mobile API's encryption key handling:
- Uses the same encryption method (BCrypt)
- Stores encryption keys in the same database table
- Uses the same salt generation approach
- Maintains consistency across web and mobile platforms

## Future Enhancements

Consider adding:
1. Password strength requirements for encryption key password
2. Confirmation field for encryption key password
3. Recovery mechanism for lost encryption keys (if business requirements allow)
4. Encryption key rotation functionality
5. Audit logging for encryption key access

## Troubleshooting

**Issue:** "User already has an encryption key" error
- This occurs if trying to create multiple encryption keys for one user
- Ensure the user doesn't already have an encryption key
- Check for duplicate registration attempts

**Issue:** Encryption key not created
- Verify `encryption_key_password` parameter is being sent
- Check controller logs for errors
- Ensure BCrypt gem is installed
- Verify database migration has run

**Issue:** Form validation errors
- Ensure all required fields are filled
- Check password meets minimum length requirements
- Verify encryption key password field is not empty
