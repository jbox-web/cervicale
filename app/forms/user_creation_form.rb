class UserCreationForm < ActionForm::Base

  PASSWORD_OPTIONS = [
    ['generate', User.human_attribute_name('generate_password')],
    ['manual',   User.human_attribute_name('specify_password')]
  ]

  self.main_model = :user

  ## Real attributes
  attribute :first_name,        required: false
  attribute :last_name,         required: false
  attribute :email,             required: false
  attribute :phone_number,      required: false
  attribute :cell_phone_number, required: false
  attribute :language,          required: false
  attribute :time_zone,         required: false
  attribute :admin,             required: false
  attribute :enabled,           required: false

  attribute :password,              required: false
  attribute :password_confirmation, required: false

  ## Virtual attributes (options)
  attr_accessor :create_options
  attr_accessor :send_by_mail
  attr_accessor :created_password

  ## Validations
  validates :create_options, presence: true, inclusion: { in: ['generate', 'manual'] }


  def user
    @model
  end


  ## Override inherited method to assign hidden attributes.
  ## (kind of alias_method_chain)
  def submit(params)
    super

    if create_options == 'generate'
      self.created_password = Devise.friendly_token.first(8)
      self.password = created_password
      self.password_confirmation = created_password
    else
      self.created_password = params[:password]
    end
  end


  def new_record?
    true
  end


  def first_admin?
    false
  end


  def send_email?
    send_by_mail == '1'
  end

end
