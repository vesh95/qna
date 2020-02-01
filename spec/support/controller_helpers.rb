module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mapping[:user]
    sign_in(user)
  end
end
