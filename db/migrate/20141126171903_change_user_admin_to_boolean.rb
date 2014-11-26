class ChangeUserAdminToBoolean < ActiveRecord::Migration
  def change
    change_column "users", "admin", "boolean"
  end
end
