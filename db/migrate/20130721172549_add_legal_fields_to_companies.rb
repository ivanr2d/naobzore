class AddLegalFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :tallage, :enum, :limit => [:common, :simple], :default => :common
    change_table :companies do |t|
      t.string :kpp
      t.string :org_form
      t.string :settlement_account
      t.string :bik
      t.string :bank_cor_account
      t.string :director_fname
      t.string :director_lname
      t.string :director_mname
    end
  end
end
