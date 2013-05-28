class AddNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification, :integer, :default => 2
  end
end
