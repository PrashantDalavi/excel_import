class Employee < ActiveRecord::Base
  validates :email, uniqueness: true
  validates :company_id, presence: true
  belongs_to :company
end
