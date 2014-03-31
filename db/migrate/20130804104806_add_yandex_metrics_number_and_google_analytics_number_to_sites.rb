class AddYandexMetricsNumberAndGoogleAnalyticsNumberToSites < ActiveRecord::Migration
  def change
    add_column :sites, :yandex_metrics_number, :string
    add_column :sites, :google_analytics_number, :string
  end
end
