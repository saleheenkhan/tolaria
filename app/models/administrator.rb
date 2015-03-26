class Administrator < ActiveRecord::Base

  before_validation :initialize_credentials!

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  validates :email, {
    presence: true,
    uniqueness: true
  }

  validates :name, {
    presence: true
  }

  validates :organization, {
    presence: true
  }

  validates :auth_token, {
    presence: true
  }

  validates :passcode, {
    presence: true
  }

  validates :passcode_expires_at, {
    presence: true
  }

  # -----------------------------------------------------------------------------
  # Authentication/passcode system
  # -----------------------------------------------------------------------------

  def authenticate(passcode)

    # Always run bcrypt first so that we incur the time pentaly
    bcrypt_valid = BCrypt::Password.new(self.passcode) == passcode

    # Reject if currently locked
    return false if self.locked?

    # Clear strikes if the passcode is valid
    # Reject and incur a strike if the challenge was failed
    if bcrypt_valid && Time.current < self.passcode_expires_at
      self.reset_strikes!
      return true
    else
      self.accrue_strike!
      return false
    end

  end

  def locked?
    return false if self.account_unlocks_at.nil?
    return Time.current < self.account_unlocks_at
  end

  def accrue_strike!
    self.update!(
      lockout_strikes: self.lockout_strikes + 1,
      total_strikes: self.total_strikes + 1,
    )
    if self.lockout_strikes >= Tolaria.config.lockout_threshold
      self.lock_account!
    end
  end


  def reset_strikes!
    self.update!(lockout_strikes: 0)
  end

  def lock_account!
    self.update!(
      account_unlocks_at: Time.now + Tolaria.config.lockout_duration,
      lockout_strikes: 0,
    )
  end

  def unlock_account!
    self.update!(
      account_unlocks_at: nil,
      lockout_strikes: 0,
    )
  end

  def set_passcode!
    passcode = Tolaria::RandomTokens.passcode
    self.update!(
      passcode: BCrypt::Password.create(passcode, cost:Tolaria.config.bcrypt_cost),
      passcode_expires_at: Time.current + Tolaria.config.passcode_lifespan,
    )
    return passcode
  end

  def initialize_credentials!
    self.passcode ||= BCrypt::Password.create(Tolaria::RandomTokens.passcode, cost:Tolaria.config.bcrypt_cost)
    self.passcode_expires_at ||= Time.current,
    self.auth_token ||= Tolaria::RandomTokens.auth_token
  end

end
