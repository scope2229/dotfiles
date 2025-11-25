# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "User Registration with Encryption Key", type: :feature do
  scenario "User registers with all required fields including encryption key password" do
    visit new_user_registration_path

    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123456"
    fill_in "Password confirmation", with: "password123456"
    fill_in "Encryption key password", with: "my_secure_encryption_key"

    click_button "Sign up"

    expect(page).to have_content("Welcome! You have signed up successfully.")
    
    user = User.find_by(email: "newuser@example.com")
    expect(user).to be_present
    expect(user.encryption_key).to be_present
    expect(user.encryption_key.encrypted_key).to be_present
    expect(user.encryption_key.salt).to be_present
  end

  scenario "User registration form displays encryption key password field" do
    visit new_user_registration_path

    expect(page).to have_field("Encryption key password")
    expect(page).to have_content("Required for secure data encryption")
    expect(page).to have_content("This password will be used to encrypt your data")
  end

  scenario "User tries to register without encryption key password" do
    visit new_user_registration_path

    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123456"
    fill_in "Password confirmation", with: "password123456"
    # Not filling in encryption key password

    click_button "Sign up"

    # The form should require the encryption key password
    expect(page).to have_content("Encryption key password") # Field should still be visible
  end

  scenario "User registers and encryption key is stored separately from account password" do
    visit new_user_registration_path

    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "account_password_123"
    fill_in "Password confirmation", with: "account_password_123"
    fill_in "Encryption key password", with: "different_encryption_password"

    click_button "Sign up"

    user = User.find_by(email: "newuser@example.com")
    
    # Account password is used for authentication (Devise handles this)
    expect(user.valid_password?("account_password_123")).to be true
    
    # Encryption key is stored separately and encrypted
    expect(user.encryption_key.encrypted_key).to be_present
    expect(user.encryption_key.encrypted_key).not_to eq("different_encryption_password")
  end
end
