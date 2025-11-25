# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EncryptionKey, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:encrypted_key) }
    it { should validate_presence_of(:salt) }
    
    context "uniqueness of user_id" do
      let(:user) { create(:user) }
      let!(:existing_key) { create(:encryption_key, user: user) }
      
      it "prevents creating multiple encryption keys for the same user" do
        new_key = build(:encryption_key, user: user)
        expect(new_key).not_to be_valid
        expect(new_key.errors[:base]).to include("User already has an encryption key")
      end
    end
  end

  describe "callbacks" do
    let(:user) { create(:user) }
    
    it "prevents creating a second encryption key for the same user" do
      create(:encryption_key, user: user)
      
      expect {
        create(:encryption_key, user: user)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "database constraints" do
    let(:user) { create(:user) }
    
    it "has a unique index on user_id" do
      create(:encryption_key, user: user)
      
      expect {
        EncryptionKey.create!(
          user: user,
          encrypted_key: "another_key",
          salt: "another_salt"
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
