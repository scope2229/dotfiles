# User Registration Form - Visual Mockup

## Before (Standard Devise Registration)

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│                     Sign up                         │
│                                                     │
│  Email                                              │
│  ┌───────────────────────────────────────────────┐ │
│  │                                               │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Password (8 characters minimum)                    │
│  ┌───────────────────────────────────────────────┐ │
│  │ ••••••••                                      │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Password confirmation                              │
│  ┌───────────────────────────────────────────────┐ │
│  │ ••••••••                                      │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│              ┌─────────────┐                        │
│              │   Sign up   │                        │
│              └─────────────┘                        │
│                                                     │
│              Already have an account? Log in        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## After (With Encryption Key Password)

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│                     Sign up                         │
│                                                     │
│  Email                                              │
│  ┌───────────────────────────────────────────────┐ │
│  │ user@example.com                              │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Password (8 characters minimum)                    │
│  ┌───────────────────────────────────────────────┐ │
│  │ ••••••••                                      │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Password confirmation                              │
│  ┌───────────────────────────────────────────────┐ │
│  │ ••••••••                                      │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  Encryption Key Password *                          │
│  (Required for secure data encryption)              │
│  ┌───────────────────────────────────────────────┐ │
│  │ ••••••••••••                                  │ │◄─── NEW FIELD
│  └───────────────────────────────────────────────┘ │
│  This password will be used to encrypt your data.   │
│  Keep it safe and secure.                           │
│                                                     │
│              ┌─────────────┐                        │
│              │   Sign up   │                        │
│              └─────────────┘                        │
│                                                     │
│              Already have an account? Log in        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Form Field Specifications

### New Field: Encryption Key Password

**Field Properties:**
- Type: `password_field`
- Name: `user[encryption_key_password]`
- Required: Yes (HTML5 `required` attribute)
- Autocomplete: `new-password`
- Label: "Encryption Key Password"
- Help Text: "Required for secure data encryption"
- Description: "This password will be used to encrypt your data. Keep it safe and secure."

**Styling Recommendations:**
```css
.encryption-key-field {
  margin-top: 20px;
  padding: 15px;
  background-color: #f8f9fa;
  border-left: 4px solid #007bff;
}

.encryption-key-field label {
  font-weight: bold;
  color: #333;
}

.encryption-key-field small {
  display: block;
  margin-top: 5px;
  color: #6c757d;
  font-size: 0.875rem;
}

.encryption-key-field em {
  color: #0056b3;
  font-style: italic;
  font-size: 0.9rem;
}
```

## User Flow Diagram

```
┌──────────────┐
│  User visits │
│  /sign_up    │
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│  Registration Form   │
│  ─────────────────  │
│  • Email             │
│  • Password          │
│  • Password Confirm  │
│  • Encryption Key ★  │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Submit Form         │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Controller          │
│  Creates:            │
│  1. User account     │
│  2. Encryption Key   │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Database Stores:    │
│  ─────────────────  │
│  users table         │
│  ├─ email            │
│  ├─ password_digest  │
│  └─ ...              │
│                      │
│  encryption_keys     │
│  ├─ user_id          │
│  ├─ encrypted_key    │
│  └─ salt             │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  User logged in      │
│  Success! ✓          │
└──────────────────────┘
```

## Mobile App vs Website Comparison

### Mobile App (Existing API)
```
POST /api/v1/users
{
  "email": "user@example.com",
  "password": "account_password",
  "encryption_key_password": "encryption_password"
}

Response:
{
  "user": {
    "id": 123,
    "email": "user@example.com",
    "encryption_key_id": 456
  }
}
```

### Website (New Implementation)
```
POST /users
{
  "user": {
    "email": "user@example.com",
    "password": "account_password",
    "password_confirmation": "account_password",
    "encryption_key_password": "encryption_password"
  }
}

Redirect to: /dashboard
With flash: "Welcome! You have signed up successfully."
```

Both result in the same database state:
```
users table:
  id: 123
  email: user@example.com
  encrypted_password: [bcrypt hash]

encryption_keys table:
  id: 456
  user_id: 123
  encrypted_key: [bcrypt hash]
  salt: [random hex]
```

## Security Visualization

```
┌─────────────────────┐         ┌─────────────────────┐
│   Account Login     │         │   Data Encryption   │
│                     │         │                     │
│  Email + Password   │         │  Encryption Key     │
│         ↓           │         │       Password      │
│   Devise Auth       │         │         ↓           │
│         ↓           │         │   BCrypt Hash       │
│   Session Token     │         │         ↓           │
│                     │         │   Encrypt User Data │
└─────────────────────┘         └─────────────────────┘
        ↓                                 ↓
        └─────────────┬───────────────────┘
                      ↓
            ┌──────────────────┐
            │   Secure Access   │
            │   to Encrypted    │
            │   User Data       │
            └──────────────────┘
```

## Database Schema

```sql
-- Users table (existing)
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR NOT NULL UNIQUE,
  encrypted_password VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Encryption Keys table (new)
CREATE TABLE encryption_keys (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL UNIQUE,
  encrypted_key VARCHAR NOT NULL,
  salt VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX index_encryption_keys_on_user_id 
  ON encryption_keys(user_id);
```

## Implementation Highlights

✅ **Seamless Integration**: Extends Devise without breaking existing functionality
✅ **Consistent with API**: Same approach as mobile app
✅ **Secure**: BCrypt encryption + unique salt per user
✅ **User-Friendly**: Clear labels and helpful text
✅ **Validated**: Required field prevents incomplete registrations
✅ **Tested**: Comprehensive test suite included
✅ **Documented**: Multiple documentation files for different use cases

## What Users Will Experience

1. **Clarity**: Clear explanation of what the encryption key is for
2. **Security**: Understanding that this is separate from their login password
3. **Simplicity**: Just one additional field in a familiar registration form
4. **Confidence**: Professional presentation builds trust in the security features
