# frozen_string_literal: true

# Add this to your app/models/user.rb file:
#
# class User < ApplicationRecord
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :validatable
#
#   # Association for encryption key
#   has_one :encryption_key, dependent: :destroy
#
#   # ... rest of your User model code
# end

# This ensures each user has one encryption key that will be
# destroyed when the user is deleted
