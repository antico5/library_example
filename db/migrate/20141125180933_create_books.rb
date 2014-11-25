class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.integer :year
      t.string :author
      t.datetime :borrowed_date
      t.integer :owner_id

      t.timestamps
    end
  end
end
