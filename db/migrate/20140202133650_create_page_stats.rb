# encoding: utf-8

class CreatePageStats < ActiveRecord::Migration
  def up
  	Page.create(
  		:title => 'Подключение внешней статистики',
  		:content => '
		  <div class="setting-statistic-item">
              <p>
              Для того, чтобы отслеживать эффективность работы вашего веб-сайта, количество посетителей и источники их появления, а также много другой полезной информации, мы предлагаем вам воспользоваться мощными и бесплатными аналитическими системами от компании Google и Яндекс - Google Analytics и Яндекс.Метрика.
              Эти системы обладают интуитивно понятными интерфейсами и доступны не только профессионалам, но и новичкам в деле раскрутки и продвижения сайтов.
              Подробнее о работе с системами аналитики для веб сайтов вы можете ознакомиться на официальных страницах Google Analytics и Яндекс.Метрика.
              </p>
          </div>

          <div class="setting-statistic-item">
              <h2 class="sub-title">Как подключиться к Яндекс.Метрике</h2>
              <p>
                  Для того, чтобы начать работу с аналитической системой Яндекс Метрика вам необходимо пройти 6 простых шагов:
                  <ul>
                      <li>Зарегистрируйтесь в службе Яндекс.Паспорт. Если Вы уже зарегистрированы в Яндекс, переходите к пункту 2.</li>
                      <li>Выполните вход в Яндекс.Метрику, введя Ваш логин и пароль.</li>
                      <li>Перейдите по ссылке "Добавить счётчик" и укажите адрес вашего сайта http://stroimasteroren.rosfirm.ru</li>
                      <li>Во вкладке "Код счетчика" Яндекс выдаст Вам JavaScript код следующего вида:<br />
                          &lt;!-- Yandex.Metrika counter --&gt;<br />
                          &lt;script src="//mc.yandex.ru/metrika/watch.js" type="text/javascript"&gt;&lt;/script&gt;<br /> 
                          &lt;div style="display:none;"&gt;&lt;script type="text/javascript"&gt; <br />
                          try { var yaCounterНОМЕР_СЧЕТЧИКА = new Ya.Metrika(НОМЕР_СЧЕТЧИКА);} catch(e){} &lt;/script&gt;&lt;/div&gt; <br />
                          &lt;noscript&gt;&lt;div style="position:absolute"&gt;&lt;img src="//mc.yandex.ru/watch/НОМЕР_СЧЕТЧИКА" alt="" /&gt;&lt;/div&gt;&lt;/noscript&gt; <br />
                          &lt;!-- /Yandex.Metrika counter --&gt; 
                      </li>
                      <li>В выбранном пункте есть следующая строка:<br />
                      &lt;img src="//mc.yandex.ru/watch/НОМЕР_СЧЕТЧИКА" alt="" /&gt;</li>
                      <li>Скопируйте номер счетчика и введите в форму ниже, затем нажмите «Сохранить настройки».</li>
                      <li>Как только вы это сделаете, Яндекс.Метрика начнет собирать и анализировать информацию о посещениях вашего сайта. Статистика становится доступна на следующий день на сайте службы.</li>
                  </ul>
              </p>
              <div class="simple-row">
                  <div class="s-field">
                      <input type"text" name="site[yandex_metrics_number]" id="site_yandex_metrics_number" size="40" value="<%= @site.yandex_metrics_number %>" />
                      <div class="example">Номер счетчика: 5-10 цифр. Например, 1591345</div>
                  </div>
                  <div class="clear"></div>
              </div>
          </div>
          
          <div class="setting-statistic-item">
              <h2 class="sub-title">Как подключиться к Google Analytics</h2>
              <p>
                  Для того, чтобы начать работу с аналитической системой Google Analytics вам необходимо пройти 3 простых шагов:
                  <ul>
                      <li>Зарегистрируйтесь в службе Google Analytics (для этого может потребоваться создать учетную запись Google, в случае если у вас ее еще нет).</li>
                      <li>Создайте профиль вашего сайта http://stroimasteroren.rosfirm.ru в службе Google Analytics.</li>
                      <li>После создания профиля, Google Analytics выдаст Вам JavaScript код следующего вида:<br />
                          &lt;script type="text/javascript"&gt;<br />
                          var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");<br />
                          document.write(unescape("%3Cscript src=\'" + gaJsHost + "google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3E"));<br />
                          &lt;/script&gt;<br />
                          &lt;script type="text/javascript"&gt;<br />
                          try {<br />
                          var pageTracker = _gat._getTracker("КОД-ОТСЛЕЖИВАНИЯ");<br />
                          pageTracker._trackPageview();<br />
                          } catch(err) {}&lt;/script&gt;<br />
                          Скопируйте код отслеживания вида UA-8цифр-1цифра, который вам дала служба Google Analytics в форму, приведенную ниже, и сохраните.
                      </li>
                      <li>Как только вы это сделаете, служба Google Analytics начнет собирать и анализировать информацию о посещениях вашего сайта. Статистика становится доступна на следующий день на сайте службы.</li>
                  </ul>
              </p>
              <div class="simple-row">
                  <div class="s-field">
                      <input type="text" name="site[google_analytics_number]" id="site_google_analytics_number" value="<%= @site.google_analytics_number %>" />
                      <div class="example">Код отслеживания: код вида UA-8цифр-1цифра. Например, UA-4584549-1</div>
                  </div>
                  <div class="clear"></div>
              </div>
          </div>
  		',
  		:link => 'stats'
  	)
  end

  def down
  	Page.find_by_link('stats').try(:destroy)
  end
end
