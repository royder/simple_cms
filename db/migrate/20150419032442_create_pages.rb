class CreatePages < ActiveRecord::Migration
  def up
    create_table :pages do |t|
      t.integer 'subject_id'
      # same as: t.references :subject
      t.string 'name'
      t.string 'permalink'
      t.integer 'position'
      t.boolean 'visible', :default => false
      t.timestamps
    end
    add_index('pages', 'subject_id')
    add_index('pages', 'permalink')
  end
  
  def down
    # remove_index('pages', 'permalink') no need to do these since they are in the table
    # remove_index('pages', 'subject_id')
    drop_table :pages
  end
end
