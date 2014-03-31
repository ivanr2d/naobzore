class AddArticleMeasureToServices < ActiveRecord::Migration
  def change
    add_column :services, :article, :integer
    add_column :services, :measure, :string, :limit => 10
  end
end
