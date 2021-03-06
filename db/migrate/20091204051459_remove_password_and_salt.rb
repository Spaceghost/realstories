class RemovePasswordAndSalt < ActiveRecord::Migration
  def self.up
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
  end

  def self.down
    add_column :users, :crypted_password, :string
    add_column :users, :password_salt, :string
  end
end
