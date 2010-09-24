require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :borrowed_books
  
  validates_presence_of :name, :email, :address, :phone_number
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => 'is invalid'
  validates_uniqueness_of :email, :message => 'is already registered to the system'
  validates_numericality_of :phone_number, :message => 'must be digits'
  validates_format_of :phone_number,
    :message => "must be a valid telephone number [10 digit number without any extensions]  ",
    :with => /^[\(\)0-9\- \+\.]{10}$/

  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validate :password_non_blank

  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end


  # 'password' is a virtual attribute

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end



  private

  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end



  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end



  def self.encrypted_password(password, salt)
    string_to_hash = password + "kodexter" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end

end


