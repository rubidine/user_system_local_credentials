ActionController::Dispatcher.to_prepare(:user_system_local_credentails) do
  unless SessionsController.read_inheritable_attribute(:auth_module)
    SessionsController.write_inheritable_attribute(:auth_module, UserSystem::LocalCredentials::Authentication)
  end
  User.send :include, UserSystem::LocalCredentials::UserModelMixin
end
