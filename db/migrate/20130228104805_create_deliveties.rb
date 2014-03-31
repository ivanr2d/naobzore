class CreateDeliveties < ActiveRecord::Migration
  def change
    create_table :deliveties do |t|
      t.integer :company_id
      t.integer :cost
      t.string :graph, :limit => 64
      t.string :period, :limit => 64

      t.timestamps
    end
  end
end
