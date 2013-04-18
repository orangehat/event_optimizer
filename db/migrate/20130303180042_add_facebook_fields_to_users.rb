class AddFacebookFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :uid, :integer
    add_column :users, :provider, :string
  end

  def self.down
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :name
  end
end
