class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :gender
      t.string :email
      t.integer :age
      t.string :contact_no

      t.timestamps
    end
  end
end
