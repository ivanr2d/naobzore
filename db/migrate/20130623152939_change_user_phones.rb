class ChangeUserPhones < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.remove :home_phone
      t.remove :mobil_phone
      t.string :phone
    end
  end

  def down
    change_table :users do |t|
      t.remove :phone
      t.string :home_phone, :limit => 32
      t.string :mobil_phone, :limit => 32
    end
  end
end
