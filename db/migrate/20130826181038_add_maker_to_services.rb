class AddMakerToServices < ActiveRecord::Migration
  def change
    add_column :services, :maker, :string
  end
end
