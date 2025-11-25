# frozen_string_literal: true

class EncryptionKey < ApplicationRecord
  belongs_to :user

  validates :encrypted_key, presence: true
  validates :salt, presence: true
  validates :user_id, uniqueness: true

  # Ensure one encryption key per user
  before_validation :ensure_one_key_per_user, on: :create

  private

  def ensure_one_key_per_user
    if user && user.encryption_key.present?
      errors.add(:base, "User already has an encryption key")
      throw(:abort)
    end
  end
end
