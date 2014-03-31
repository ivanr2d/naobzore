class CreateTableCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.integer :good_id
      t.string :key, :limit => 64
      t.string :value, :limit => 128

      t.timestamps
    end
  end
end
