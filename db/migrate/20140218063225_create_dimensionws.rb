class CreateDimensionws < ActiveRecord::Migration
  def change
    create_table :dimensionws do |t|
      t.string :name

      t.timestamps
    end
  end
end
