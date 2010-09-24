class AddTypeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type, :char, :default => 'e'
  end

  def self.down
    remove_column :users, :type
  end
end
