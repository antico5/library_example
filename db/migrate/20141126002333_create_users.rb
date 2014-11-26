class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :token
      t.string :admin

      t.timestamps
    end
  end
end
