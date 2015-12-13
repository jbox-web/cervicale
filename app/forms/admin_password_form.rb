class AdminPasswordForm < ActionForm::Base

  self.main_model = :user

  ## Virtual attributes : needed to update current password
  attr_accessor :password

  ## Virtual attributes (options)
  attr_accessor :create_options
  attr_accessor :send_by_mail

  ## Validations
  validates :create_options,  presence: true, inclusion: { in: [ 'generate', 'manual' ] }
  validates :password, length: { minimum: 6 }
  validates_confirmation_of :password


  def user
    @model
  end


  ## Override inherited method to assign virtual attributes (attr_accessor).
  ## (kind of alias_method_chain)
  def submit(params)
    super

    if create_options == 'generate'
      generated_password = Devise.friendly_token.first(8)
      self.password = generated_password
      self.password_confirmation = generated_password
    end

    ## Assign real attributes
    user.password = password
    user.password_confirmation = password
  end


  def send_email?
    send_by_mail == '1'
  end

end
