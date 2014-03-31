class CreateEmailTemplates < ActiveRecord::Migration
  def up
    create_table :email_templates do |t|
      t.string :name, :null => false
      t.string :description
      t.text :body, :null => false

      t.timestamps
    end
    add_index :email_templates, :name
  end

  def down
    drop_table :email_templates
  end
end
