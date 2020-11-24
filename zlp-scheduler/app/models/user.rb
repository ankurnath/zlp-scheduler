class User < ApplicationRecord
  has_secure_password
  has_many :schedules, dependent: :destroy
  has_one :cohort
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :password, presence: true,
                       length: { within: 4..20 },
                       confirmation: true,
                       if: :password_digest_changed?

  def email=(value)
    value = value.strip.downcase
    write_attribute :email, value
  end

  # role-based authorization
  def student?
    role == 'student'
  end

  def admin?
    role == 'admin'
  end

  # password_reset email, should expire after sometime.
  def send_password_reset
    generate_token(:password_reset_token)
    update_attributes!(password_reset_sent_at: Time.zone.now)
    UserMailer.password_reset(self).deliver
  end

  private

  # accepts a column name and uses secure random to genearate a random string as token and makes sure token is unique.
  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless User.exists?(column => self[column])
    end
  end
end
