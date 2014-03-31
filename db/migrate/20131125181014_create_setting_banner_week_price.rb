# encoding: utf-8

class CreateSettingBannerWeekPrice < ActiveRecord::Migration
  def up
    Settings.create(:key => :banner_week_price, :value => 1199, :title => 'Цена размещения баннера на неделю')
  end

  def down
    Settings.find_by_key(:banner_week_price).try(:destroy)
  end
end
