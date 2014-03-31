# encoding: utf-8

class CreatePageSitemap < ActiveRecord::Migration
  def up
  	Page.create(
  		:title => 'Sitemap',
  		:content => '
  			<div class="info">
    Файл Sitemap — это файл, расположенный на сайте, с дополнительной информацией о страницах сайта, подлежащих индексированию. С помощью файла Sitemap вы можете сообщить Яндексу, какие страницы вашего сайта нужно индексировать, как часто обновляется информация на страницах, а также индексирование каких страниц наиболее важно.
                Файлы Sitemap учитываются при обходе сайта, однако мы не гарантируем, что все URL из вашего файла Sitemap будут добавлены в поисковый индекс Яндекса.
                Вы можете сообщить Яндексу о наличии файла Sitemap для своего сайта двумя способами:
                добавив URL файла Sitemap в разделе «Файлы Sitemap» сервиса Яндекс.Вебмастер;
                добавив директиву Sitemap в файле robots.txt вашего сайта.
                Яндекс поддерживает перекрестную отправку файлов Sitemap.
		  </div>
		  <div class="body-blue">
		    <div class="row">
		      <div class="label"><label>Ссылка на файл</label></div>
		      <div class="field default">
		        <a id="sitemap" href="http://<%= @site.subdomen %>.naobzore.ru/sitemap.xml" download="sitemap.xml">http://<%= @site.subdomen %>.naobzore.ru/sitemap.xml</a>
		        &nbsp;&nbsp;
		        <!--<a href="javascript:" id="copy_sitemap">Копировать</a>-->
		      </div>
		      <div class="clear"></div>
		    </div>
		  </div>
  		',
  		:link => 'sitemap'
  	)
  end

  def down
  	Page.find_by_link!('sitemap').destroy
  end
end
