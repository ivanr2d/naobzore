class AddCodeToDeliveties < ActiveRecord::Migration
  def change
    add_column :deliveties, :code, :string
  end
end
