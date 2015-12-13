class SessionsController < Devise::SessionsController

  def create
    super do |resource|
      User.current = resource if resource.is_a?(User)
    end
  end


  def destroy
    super do |resource|
      User.current = nil
    end
  end

end
