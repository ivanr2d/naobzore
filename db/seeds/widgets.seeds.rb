# encoding: utf-8
# XXX move widgets to partials and load them to db by rake task

Widget.delete_all
Widget.create([
{
  "dual"=>false, 
  "pos"=>0, 
  "text"=>'
    <ul>
      <li>
        <a href="<%= company_panel_goods_path %>">Товаров и услуг <span class="txt-blue"><%= current_user.company.goods.count + current_user.company.services.count %></span> из <%= current_user.company.goods_and_services_limit %></a>
      </li>
      <li>
        <a href="<%= company_panel_jobs_path %>">Вакансий <span class="txt-blue"><%= current_user.company.jobs.count %></span> из <%= current_user.company.jobs_limit %></a>
      </li>
      <li>
        <a href="">Акций/Скидок <span class="txt-blue"><%= current_user.company.campaigns.count %></span> из <%= current_user.company.campaigns_limit %></a>
      </li>
    </ul>', 
  "title"=>"Статус: <span><%= t('activerecord.activation_statuses.' + current_user.company.status.to_s) %></span>", 
  "translit"=>"user_status"
},
{
  "dual"=>false, 
  "pos"=>0, 
  "text"=>'
    <ul>
      <li>
        <a href="<%= stats_company_panel_site_path(current_user.account.site.id) %>">Внешняя статистика</a>
      </li>
      <li>
        <a href="<%= webmaster_company_panel_site_path(current_user.account.site.id) %>">Инстументы вэбмастера</a>
      </li>
      <li>
        <a href="<%= sitemap_company_panel_site_path(current_user.account.site.id) %>">Карта сайта</a>
      </li>
      <li>
        <a href="<%= robots_company_panel_site_path(current_user.account.site.id) %>">Управление robots</a>
      </li>
    </ul>', 
  "title"=>"Web-инструменты", 
  "translit"=>"webmaster"
},
{
  "dual"=>false, 
  "pos"=>1, 
  "text"=>'
    <ul>
      <li>
        <a href="#">
          <img src="/controlPanel/images/bell.png" alt="" />
        </a>
      </li>
      <li>
        ICQ: <span class="txt-blue"><%= number_with_delimiter(Settings.find_by_key(:support_icq).value, :delimmiter => "-") %></span>
      </li>
      <li>
        Номер: <span class="txt-blue"><%= number_to_phone(Settings.find_by_key(:support_phone).value) %></span>
      </li>
      <li>
        <a href="#" class="blue-button">Написать сообщение</a>
      </li>
    </ul>', 
  "title"=>"Служба поддержки", 
  "translit"=>"support_service"
},
{
  "dual"=>false, 
  "pos"=>1, 
  "text"=>'
    <ul>
      <li>
        <a href="">Отправлено <span class="txt-blue"></span></a>
      </li>
      <li>
        <a href="">Доступно <span class="txt-blue"></span></a>
      </li>
      <li>
        <a href="">База подписчиков</a>
      </li>
      <li>
        <a href="">Купить пакет SMS</a>
      </li>
    </ul>', 
  "title"=>"SMS - рассылка", 
  "translit"=>"sms"
},
{
  "dual"=>false, 
  "pos"=>1, 
  "text"=>'
    <ul>
      <li><%= current_user.account.site.main_url %></li>
      <%= current_user.account.subdomains.map { |s| "<li>" + Site.url_with_subdomain(s.name) + "</li>" }.join %>
      <li><a href="<%= company_panel_subdomains_path %>"><span class="txt-blue">Изменить</span></a></li>
    </ul>', 
  "title"=>"Адрес Вашего сайта", 
  "translit"=>"minisite"
},
{
  "dual"=>false, 
  "pos"=>2, 
  "text"=>'
    <ul>
      <li>
        <%= link_to_unless_current "Операции по счетам", movement_company_panel_invoices_path, :class => "txt-blue" do "Операции по счетам" end %>
      </li>
      <li>
        <%= link_to_unless_current "Пополнение счёта", new_company_panel_invoice_path, :class => "txt-blue" do "Пополнение счёта" end %>
      </li>
      <li>
        <%= link_to_unless_current "Счета#{counter(current_user.company.invoices.unread_by(current_user).count)}", company_panel_invoices_path, :class => "txt-blue" do "Счета" end %>
      </li>
      <li>
        <%= link_to_unless_current "Счёт-фактуры#{counter(current_user.company.factures.unread_by(current_user).count)}", company_panel_factures_path, :class => "txt-blue" do "Счёт-фактуры" end %>
      </li>
      <li>
        <%= link_to_unless_current "Акты выполненных работ#{counter(current_user.company.acts.unread_by(current_user).count)}", company_panel_acts_path, :class => "txt-blue" do "Акты выполненных работ" end %>
      </li>
    </ul>', 
  "title"=>"<%= current_user.company.human_balance %>", 
  "translit"=>"balance"
},
{
  "dual"=>false, 
  "pos"=>2, 
  "text"=>'
    <ul>
      <li><a href="">Детализация звонков</a></li>
      <li><a href="">Осталось минут <span class="txt-blue"></span></a></li>
      <li><a href="">Купить пакет минут</a></li>
    </ul>', 
  "title"=>"Менеджер звонков", 
  "translit"=>"calls"
},
{
  "dual"=>false, 
  "pos"=>3, "text"=>'
    <ul>
      <li><a href="/company_panel/mail" class="txt-blue">Панель управления</a></li>
      <li><a href="/company_panel/messages" class="txt-blue">Сообщения<%= counter(current_user.received_messages.unread_by(current_user).count) %></a></li>
      <li><a href="/company_panel/emails" class="txt-blue">Рассылки</a></li>
      <li><a href="/company_panel/sms" class="txt-blue">Sms-биллинг</a></li>
      <li><a href="/company_panel/calls" class="txt-blue">Менеджер звонков</a></li>
    </ul>', 
  "title"=>"Почта и связь", 
  "translit"=>"mail_connection"
},
{
  "dual"=>true, 
  "pos"=>4, 
  "text"=>'
    <% tutorial = Tutorial.last %>
    <table><tr><td>
      <a href="<%= company_panel_tutorials_path %>">
        <img src="<%= tutorial.preview_url(:big) %>" style="max-width:166px; max-height:166px;" />
      </a>
    </td><td valign="top">
      <b><%= tutorial.title %></b><br />
      <%= truncate tutorial.text, :length => 500 %><br />
      <%= link_to "Подробнее", company_panel_tutorials_path %>
    </td></tr></table>
  ',
  "title"=>"Возможности наОбзоре.рф", 
  "translit"=>"possibilities"
},
{
  "dual"=>false, 
  "pos"=>5, 
  "text"=>'
    <ul>
      <li><a href="/company_panel/packages/placing" class="txt-blue">Пакеты размещения</a></li>
      <li><a href="/company_panel/banners/new" class="txt-blue">Размещение рекламного баннера</a></li>
      <li><a href="/company_panel/packages/communication" class="txt-blue">Пакеты смс и голосовой телефонии</a></li>
      <li><a href="/company_panel/pages/apo_design" class="txt-blue">Услуги дизайна</a></li>
    </ul>',
  "title"=>"Платные услуги", 
  "translit"=>"pay_services"
},
{
  "dual"=>true, 
  "pos"=>6, 
  "text"=>nil, 
  "title"=>"Статистика просмотров", 
  "translit"=>"view_statistics"
},
{
  "dual"=>false, 
  "pos"=>7, 
  "text"=>'
    <ul>
      <li><%= link_to "Добавить товар", new_company_panel_good_path, :class => "txt-blue" %></li>
      <li><%= link_to "Добавить услугу", new_company_panel_service_path, :class => "txt-blue" %></li>
      <li><%= link_to "Добавить вакансию", new_company_panel_job_path, :class => "txt-blue" %></li>
      <li><%= link_to "Добавить акцию/скидку", new_company_panel_campaign_path, :class => "txt-blue" %></li>
      <li><%= link_to "Добавить новость", new_company_panel_news_path, :class => "txt-blue" %></li>
    </ul>', 
  "title"=>"Добавление", 
  "translit"=>"adding"
},
{
  "dual"=>false, 
  "pos"=>8, 
  "text"=>nil, 
  "title"=>"На всякий", 
  "translit"=>"reserve"
},
{
  "dual"=>false, 
  "pos"=>9, 
  "text"=>'
    <ul>
      <li><a href="">Новости компании</a></li>
      <li><a href="">Наши акции</a></li>
      <li><a href="">Наши скидки</a></li>
    </ul>', 
  "title"=>"<span>Информационный блок</span>", 
  "translit"=>"information"
},
{
  "dual"=>false,
  "pos"=>0,
  "text"=>'
    <ul>
      <% (@menu_links || menu_siblings(@menu_controller)).each do |link| %>
        <% link.symbolize_keys! %>
        <li><%= link_to_unless_current link[:name], parse_erb(link[:href]), :class => "txt-blue" %></li>
      <% end %>
    </ul>
  ',
  "title"=>"<%= @menu_title || 'Меню' %>",
  "translit"=>"menu"
}
])
