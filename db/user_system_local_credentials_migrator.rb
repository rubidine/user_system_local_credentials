class UserSystemLocalCredentialsMigrator < ActiveRecord::Migrator
  def initialize direction, migrations_path, target_version=nil
    unless ActiveRecord::Base.connection.supports_migrations?
      raise StandardError.new("This database does not yet support migrations")
    end
    initialize_schema_migrations_table(ActiveRecord::Base.connection)
    @direction, @migrations_path, @target_version = direction, migrations_path, target_version
  end

  def self.schema_migrations_table_name
    'plugin_schema_migrations_user_system_local_credentials'
  end

  private
  def initialize_schema_migrations_table connection
    name = self.class.schema_migrations_table_name
    return if connection.tables.detect{|t| t == name}
    connection.create_table(name, :id => false) do |t|
      t.column :version, :string, :null => false
    end
    connection.add_index(
      name,
      :version,
      :unique => true,
      :name => "unique_schema_us_local_cred"
    )
  end
end
