class AddCompanyIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :company_id, :integer
  end
end
