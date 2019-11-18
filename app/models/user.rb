# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders

  def paprika_credentials
    raise "Paprika email not set" if paprika_email.blank?
    raise "Paprika password not set" if paprika_password.blank?

    "#{paprika_email} #{paprika_password}"
  end
end
