# encoding: utf-8

class CreateWidgetsForSiteControlPanel < ActiveRecord::Migration
  def up
    Widget.create(:title => 'Адрес Вашего сайта', :text => "
      <ul>
        <li><%= current_user.account.site.main_url %></li>
        <%= current_user.account.subdomains.map { |s| '<li>' + Site.url_with_subdomain(s.name) + '</li>' }.join %>
        <li><a href='<%= company_panel_subdomains_path %>'><span class='txt-blue'>Изменить</span></a></li>
      </ul>", :translit => 'minisite')
    Widget.create(:title => 'Web-инструменты', :text => '
      <ul>
        <li><a href="<%= stats_company_panel_site_path(current_user.account.site.id) %>">Внешняя статистика</a></li>
        <li><a href="<%= webmaster_company_panel_site_path(current_user.account.site.id) %>">Инстументы вэбмастера</a></li>
        <li><a href="<%= sitemap_company_panel_site_path(current_user.account.site.id) %>">Карта сайта</a></li>
        <li><a href="<%= robots_company_panel_site_path(current_user.account.site.id) %>">Управление robots</a></li>
      </ul>', :translit => 'webmaster')
  end

  def down
    Widget.where(:translit => %w(minisite webmaster)).destroy_all
  end
end
