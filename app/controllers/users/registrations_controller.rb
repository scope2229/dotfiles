# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  
  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    # Handle encryption key password
    encryption_password = params[:user][:encryption_key_password]
    
    resource.save
    yield resource if block_given?
    
    if resource.persisted?
      # Create encryption key with the provided password
      if encryption_password.present?
        create_encryption_key(resource, encryption_password)
      end
      
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:encryption_key_password])
  end

  private

  def create_encryption_key(user, password)
    # Generate encryption key using the provided password
    # This should match the API implementation for mobile apps
    EncryptionKey.create!(
      user: user,
      encrypted_key: encrypt_key(password),
      salt: generate_salt
    )
  end

  def encrypt_key(password)
    # Implement encryption logic here
    # This should match your API's encryption implementation
    # For example, using bcrypt or another encryption method
    require 'bcrypt'
    BCrypt::Password.create(password)
  end

  def generate_salt
    # Generate a random salt for the encryption key
    SecureRandom.hex(32)
  end
end
