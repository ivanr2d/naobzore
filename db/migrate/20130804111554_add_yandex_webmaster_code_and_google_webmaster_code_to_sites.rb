class AddYandexWebmasterCodeAndGoogleWebmasterCodeToSites < ActiveRecord::Migration
  def change
    add_column :sites, :yandex_webmaster_code, :string
    add_column :sites, :google_webmaster_code, :string
  end
end
