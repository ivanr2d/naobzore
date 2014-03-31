class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :category_id
      t.integer :company_id
      t.string :name
      t.text :text
      t.integer :status
      t.string :banner
      t.integer :mode

      t.timestamps
    end
  end
end
