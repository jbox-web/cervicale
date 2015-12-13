class Admin::UsersController < Admin::DefaultController

  include EasyCRUD::Base
  include EasyDCI::Controller
  include BaseController::DCICustom

  set_dci_context 'UserContext'

  crudify 'user',
          namespace: 'admin',
          crumbable: true,
          crumbs_opts: { icon: 'fa-users' },
          params: {
            on_create: [:first_name, :last_name, :email, :phone_number, :cell_phone_number, :language, :time_zone, :admin, :enabled, :theme, :password, :password_confirmation, :create_options, :send_by_mail],
            on_update: [:first_name, :last_name, :email, :phone_number, :cell_phone_number, :language, :time_zone, :admin, :enabled, :theme]
          }


  def show
    render_404
  end


  def change_password
    if request.patch?
      set_dci_data({ user: [:password, :password_confirmation, :send_by_mail, :create_options] })
      call_dci_context(:change_password, @user) do
        sign_in(@user, bypass: true) if @user.id == User.current.id
      end
    else
      render locals: { user: AdminPasswordForm.new(@user) }
    end
  end


  private


    def locals_for_new
      { user: UserCreationForm.new(User.new) }
    end


    def add_breadcrumbs(action: action_name)
      super
      if action_name == 'change_password'
        add_crumb @user.full_name, edit_admin_user_path(@user)
        add_crumb t('.title'), '#'
      end
    end


    def redirect_url_on_change_password
      edit_admin_user_path(@user)
    end

end
