# frozen_string_literal: true

FactoryBot.define do
  factory :encryption_key do
    association :user
    encrypted_key { BCrypt::Password.create("encryption_password") }
    salt { SecureRandom.hex(32) }
  end
end
