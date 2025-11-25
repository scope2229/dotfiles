# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "with valid parameters including encryption key password" do
      let(:valid_params) do
        {
          user: {
            email: "test@example.com",
            password: "password123",
            password_confirmation: "password123",
            encryption_key_password: "encryption_password123"
          }
        }
      end

      it "creates a new user" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "creates an encryption key for the user" do
        expect {
          post :create, params: valid_params
        }.to change(EncryptionKey, :count).by(1)
      end

      it "associates the encryption key with the user" do
        post :create, params: valid_params
        user = User.last
        expect(user.encryption_key).to be_present
      end

      it "encrypts the encryption key password" do
        post :create, params: valid_params
        encryption_key = EncryptionKey.last
        expect(encryption_key.encrypted_key).to be_present
        expect(encryption_key.encrypted_key).not_to eq("encryption_password123")
      end

      it "generates a salt for the encryption key" do
        post :create, params: valid_params
        encryption_key = EncryptionKey.last
        expect(encryption_key.salt).to be_present
        expect(encryption_key.salt.length).to eq(64) # 32 bytes in hex = 64 characters
      end

      it "signs in the user" do
        post :create, params: valid_params
        expect(controller.current_user).to be_present
      end
    end

    context "with valid parameters but no encryption key password" do
      let(:params_without_encryption_key) do
        {
          user: {
            email: "test@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end

      it "creates a user but no encryption key" do
        expect {
          post :create, params: params_without_encryption_key
        }.to change(User, :count).by(1)
        
        expect(EncryptionKey.count).to eq(0)
      end
    end

    context "with invalid user parameters" do
      let(:invalid_params) do
        {
          user: {
            email: "invalid_email",
            password: "short",
            password_confirmation: "short",
            encryption_key_password: "encryption_pass"
          }
        }
      end

      it "does not create a user" do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it "does not create an encryption key" do
        expect {
          post :create, params: invalid_params
        }.not_to change(EncryptionKey, :count)
      end
    end
  end
end
