class AddDirectorSignatureAndPrintAndMainToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :director_signature, :string
    add_column :companies, :print, :string
    add_column :companies, :main, :boolean, :default => false
  end
end
