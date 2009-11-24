# desc "Explaining what the task does"
# task :user_system_local_credentials do
#   # Task goes here
# end

namespace 'user_system_local_credentials' do

  desc 'run migrations'
  task 'migrate' => 'environment' do
    ActiveRecord::Base.establish_connection
    require File.join(File.dirname(__FILE__), '..', 'db', 'user_system_local_credentials_migrator')
    UserSystemLocalCredentialsMigrator.migrate(
      File.join(File.dirname(__FILE__), '..', 'db', 'migrate'),
      ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    )
  end

end
