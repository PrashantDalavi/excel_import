class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.text :company_address

      t.timestamps
    end
  end
end
