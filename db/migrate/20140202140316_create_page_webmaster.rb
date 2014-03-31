# encoding: utf-8

class CreatePageWebmaster < ActiveRecord::Migration
  def up
  	Page.create(
  		:title => 'Настройка инструментов вебмастера',
  		:content => '
		    	  <div class="setting-statistic-item">
                      <p>
                      Для того, чтобы узнать, каким видят ваш сайт Яндекс и Google, 
                      своевременно устранять проблемы и улучшать видимость вашего 
                      сайта для этих поисковых систем, настоятельно рекомендуется 
                      зарегистрировать ваш сайт в этих сервисах. Это просто и бесплатно!
                      </p>
                  </div>
      
                  <div class="setting-statistic-item">
                      <h2 class="sub-title">Подключение к Яндекс.Вебмастер в 7 шагов</h2>
                      <p>
                          Для подключения к инструментам Яндекс.Вебмастер вам необходимо зарегистрировать сайт в Яндексе и подтвердить свои права на управление сайтом:
                          <ul>
                              <li>Зарегистрируйтесь в службе Яндекс.Паспорт. Если Вы уже зарегистрированы в Яндекс, переходите к пункту 2.</li>
                              <li>Выполните вход в Яндекс, введя Ваш логин и пароль.</li>
                              <li>Добавьте сайт http://stroimasteroren.rosfirm.ru в Яндекс.Вебмастер по ссылке http://webmaster.yandex.ru/site/add.xml?hostname=stroimasteroren.rosfirm.ru&do=add</li>
                              <li>Вам будет предложено два варианта подтверждения прав, выберите второй — «Разместить мета-тэг». Не нажимайте «Проверить».</li>
                              <li>В выбранном пункте есть следующая строка:<br />
                                  &lt;meta name=\'yandex-verification\' content=\'код подтверждения\' /&gt;
                              </li>
                              <li>Скопируйте код подтверждения и введите в форму ниже, затем нажмите «Сохранить настройки».</li>
                              <li>После сохранения настроек нажмите кнопку «Проверить» на странице      Яндекс.Вебмастера.</li>
                          </ul>
                      </p>
                      <div class="simple-row">
                          <div class="s-field">
                          	<input type="text" name="site[yandex_webmaster_code]" id="site_yandex_webmaster_code" value="<%= @site.yandex_webmaster_code %>" site="40" />
                            <div class="example">Код подтверждения для Яндекса. Например: 5dc42fc63a1017c0</div>
                          </div>
                          <div class="clear"></div>
                      </div>
                      <p>
                          После подключения Яндекс.Вебмастер Вы сможете сделать дополнительные настройки используя вашу регистрицию:
                          указать регион вашего сайта. Это важно для продвижения вашего сайта в определенном регионе, т.к. региональная принадлежность повышает шансы вашего сайта выйти в топ 10 Яндекса по нужным вам запросам.
                          указать контактные данные и сферу деятельности. Эти данные будут доступны пользователям, даже в том случае, если ваш сайт окажется недоступным.
                      </p>
                  </div>
                  
                  <div class="setting-statistic-item">
                      <h2 class="sub-title">Подключение к Google Инструменты для веб-мастеров в 5 шагов</h2>
                      <p>
                          Для подключения к инструментам Google Webmaster Tools вам необходимо зарегистрировать сайт в Google и подтвердить свои права на управление сайтом:
                          <ul>
                              <li>Перейдите на сайт http://www.google.com/webmasters/tools/</li>
                              <li>Добавьте свой сайт, перейдя по ссылке «Добавить сайт».</li>
                              <li>В форме подтверждения прав на управление сайтом выберите метод подтверждения «Добавить мета-тег».</li>
                              <li>После выбора способа подтверждения Google выдаст Вам код вида<br />
                                  &lt;meta name="google-site-verification" content="код подтверждения" /&gt;
                              </li>
                              <li>Код подтверждения для Google. Например: B85ZBjnRqIjKZ9C333Y8ui6MgnuDvJ+uJJ6QddfRR0g=</li>
                          </ul>
                      </p>
                      <div class="simple-row">
                          <div class="s-field">
                          	<input type="text" name="site[google_webmaster_code]" id="site_google_webmaster_code" value="<%= @site.google_webmaster_code %>" />
                            <div class="example">Номер счетчика: 5-10 цифр. Например, 1591345</div>
                          </div>
                          <div class="clear"></div>
                      </div>
                  </div>
  		',
  		:link => 'webmaster'
  	)
  end

  def down
  	Page.find_by_link!('webmaster').destroy
  end
end
