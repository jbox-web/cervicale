class UserContext < EasyDCI::Context

  def create(params = {})
    user_form = UserCreationForm.new(User.new)
    user_form.submit(params)
    if user_form.save
      send_email(:welcome, user_form.user, user_form.created_password) if user_form.send_email?
      render_success
    else
      render_failure(locals: { user: user_form })
    end
  end


  def update(user, params = {})
    if user.update(params)
      render_success
    else
      render_failure(locals: { user: user })
    end
  end


  def delete(user)
    user.destroy ? render_success : render_failure(locals: { user: user })
  end


  def change_password(user, params = {})
    password_form = AdminPasswordForm.new(user)
    password_form.submit(params)
    if password_form.save
      yield if block_given?
      send_email(:password_changed, user, password_form.password) if password_form.send_email?
      render_success
    else
      render_failure(locals: { user: password_form })
    end
  end


  private


    def send_email(method, user, password)
      RegistrationMailer.send(method, user, password).deliver_now
    end

end
