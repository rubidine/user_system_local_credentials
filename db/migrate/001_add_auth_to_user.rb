class AddAuthToUser < ActiveRecord::Migration
  def self.up
    add_column User.table_name, :passphrase, :string
  end
end
