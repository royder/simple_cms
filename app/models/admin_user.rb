class AdminUser < ActiveRecord::Base
  
  # To configure a different table name
  # self.table_name = 'admin_users'
  # we automatically get access to attributes based on the column
  # names from ActiveRecord::Base
  
  has_and_belongs_to_many :pages
  has_many :section_edits
  
end