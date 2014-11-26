class AddIndexesToBook < ActiveRecord::Migration
  def change
    add_index "books", "borrowed_date"
    add_index "books", "name"
  end
end
