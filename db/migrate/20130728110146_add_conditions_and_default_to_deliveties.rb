class AddConditionsAndDefaultToDeliveties < ActiveRecord::Migration
  def change
    add_column :deliveties, :conditions, :text
    add_column :deliveties, :default, :boolean, :default => false
  end
end
